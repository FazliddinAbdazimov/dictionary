import 'dart:convert';
import 'dart:developer' as devtools show log;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../logger.dart';
import '../exception/exceptions.dart';

part 'interceptor.dart';

enum ApiMethods { get, post, put, delete, patch }

class ApiBase {
  const ApiBase._();

  static const _token = "419331ff2aee15f124a3de4508dd41439280ec77";
  static const baseUrl = "https://owlbot.info/api/v4/dictionary/";

  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1),
    sendTimeout: const Duration(minutes: 1),
    validateStatus: (status) => (status != null && status < 205),
  ));

  static Dio get dio => _dio..interceptors.add(ApiInterceptor());

  static Dio get refreshDio => _dio;

  // static hhtt() {
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  //     client.badCertificateCallback = (cert, host, port) => true;
  //     return client;
  //   };
  //   return _dio;
  // }

  static Future<bool> hasConnection() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi) return true;
    return false;
  }

  static Future<String> request(
    String path, {
    ApiMethods method = ApiMethods.get,
    bool setToken = true,
    Map<String, Object?>? params,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    FormData? formData,
  }) async {
    int;
    if (!(path.contains("http://") || path.contains("https://"))) {
      path = "$baseUrl$path";
    }

    if (!await hasConnection()) throw ConnectionException();

    Map<String, Object?> newHeaders = <String, Object?>{
      "Content-Type": formData != null ? "multipart/form-data" : "application/json; charset=UTF-8"
    };
    newHeaders.addAll(<String, Object?>{"Authorization": "Token $_token"});

    if (headers != null) newHeaders.addAll(headers);

    var response = await dio.request<dynamic>(
      path,
      data: params ?? formData,
      queryParameters: queryParams,
      options: Options(
        method: method.name,
        headers: newHeaders,
      ),
    );

    if (response.statusCode == null || response.statusCode! > 204 || response.data == null) {
      severe("${response.statusCode} --- ${response.data} --- ${response.statusMessage}");
      if (response.statusCode! < 500) throw NotFound();
      throw ServerException(response);
    }
    return json.encode(response.data);
  }
}
