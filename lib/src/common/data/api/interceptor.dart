part of 'api_base.dart';

extension Log on Object {
  void log() {
    bool $Debug = false;
    assert($Debug = true);
    if ($Debug) devtools.log(toString());
  }
}

class ApiInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    """
----------------------------------------------------------
  *** ON_ERROR ***
      URL: ${err.response?.realUri}
      Message: ${err.message}"""
            "\n------------------------------------------------------------- "
        .log();
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    """
-----------------------------------------------
  *** ON_REQUEST(${options.method}) ***
      URL: ${options.uri}
      Data: ${options.data}
      QueryParameters: ${options.queryParameters}
      Headers: ${options.headers}"""
            "\n------------------------------------------------------------- "
        .log();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    """
---------------------------------------------------------
  *** ON_RESPONSE(${response.statusCode}) ***
      URL: ${response.realUri}
      Data: ${response.data}"""
            "\n------------------------------------------------------------- "
        .log();
    return handler.next(response);
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    requestOptions.headers["Authorization"] = "Token ${ApiBase._token}";

    final options = Options(method: requestOptions.method, headers: requestOptions.headers);
    var response = await ApiBase.refreshDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
    return response;
  }
}
