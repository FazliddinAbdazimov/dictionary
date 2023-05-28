import 'package:dio/dio.dart';

abstract class MyException {}

class ConnectionException extends MyException {}

class NotFound extends MyException {}

class ServerException extends MyException {
  final Response response;

  ServerException(this.response);
}