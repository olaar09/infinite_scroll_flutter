import 'dart:async';
import "package:dio/dio.dart";

class RequestResponse<T> {
  static const STATUS_SUCCESS = "success";
  static const STATUS_FAIL = "failed";
  static const STATUS_OK = 200;

  String? status;
  int? statusCode;

  var data;
  String? error;

  RequestResponse._({this.status, this.statusCode, this.data, this.error});

  factory RequestResponse.fromResponseString(json) {
    return new RequestResponse._(
      status: 'success',
      statusCode: 200,
      data: json, // array of data
    );
  }
}

class RestClientRepository {
  String baseUrl = '';

  Dio init() {
    Dio _dio = new Dio();
    _dio.interceptors.add(new ApiInterceptors());
    _dio.options.baseUrl = "$baseUrl";
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Content-type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    print(options.data);
    print(options.uri);
    print(options.method);
    return super.onRequest(options, handler);
  }

  @override
  onError(DioError dioError, ErrorInterceptorHandler handler) {
    String errorString = '';

    if (dioError.response != null) {
      if (dioError.response!.statusCode == 422) {
        errorString = 'Input validation error: 422';
      } else if (dioError.response!.statusCode == 400) {
        errorString = 'Bad request: 400 ';
      } else if (dioError.response!.statusCode == 403) {
        errorString = 'UnAuth request: 403 ';
      } else if (dioError.response!.statusCode == 401) {
        errorString = 'You are not authorised to perform this action: 401';
      } else if (dioError.response!.statusCode == 500) {
        errorString = 'An internal error occurred: 500';
      } else if (dioError.response!.statusCode == 404) {
        errorString = 'An internal error occurred: 404';
      } else {
        errorString = 'An error occurred completing your request, ';
      }
    } else {
      errorString = 'Please check your internet and try again';
      // call  bugsnag.
    }

    if (dioError.response == null) {
      dioError.error = RequestResponse._(
        status: 'failed',
        statusCode: 0,
        error: 'Error: $errorString',
      );
    } else {
      dioError.error = RequestResponse._(
        status: 'failed',
        statusCode: dioError.response!.statusCode,
        error: 'Error: $errorString',
      );
    }

    return super.onError(dioError, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    response.data = RequestResponse.fromResponseString(response.data);
    return super.onResponse(response, handler);
  }
}
