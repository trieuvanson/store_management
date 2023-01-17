import 'package:dio/dio.dart';

import 'logger.dart';

class LoggingInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler) {
    var message = {
      "TYPE": "REQUEST",
      'REQUEST BASE_URL:': options.baseUrl,
      'REQUEST PATH':options.path,
      'REQUEST HEADER:': options.headers,
      'REQUEST PARAMS:': options.queryParameters,
      'REQUEST METHOD:': options.method,
      'REQUEST BODY': options.data
    };
    logger.i(message);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response,ResponseInterceptorHandler handler) {
    var message = {
      "TYPE": "RESPONSE",
      'RESPONSE BASE_URL:': response.requestOptions.baseUrl,
      'RESPONSE PATH':response.requestOptions.path,
      'RESPONSE QUERY':response.requestOptions.queryParameters,
      'RESPONSE HEADER:': response.requestOptions.headers,
      'RESPONSE METHOD:': response.requestOptions.method,
      // 'RESPONSE BODY': response.data,
      "RESPONSE STATUS CODE  ":response.statusCode,
      "RESPONSE STATUS MESSAGE":response.statusMessage
    };
    logger.i(message);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err,ErrorInterceptorHandler errorInterceptorHandler) {
    var message = {
      "TYPE": "ERROR",
      'ERROR RESPONSE BASE_URL':err.response?.requestOptions.baseUrl ?? "",
      'ERROR RESPONSE PATH':err.response?.requestOptions.path ?? "",
      'ERROR RESPONSE STATUS CODE':err.response?.statusCode ?? "",
      'ERROR RESPONSE STATUS MESSAGE ':err.response?.statusMessage ?? "",
      'ERROR RESPONSE STATUS METHOD ':err.response?.requestOptions.method ?? "",
      'ERROR RESPONSE STATUS HEADERS ':err.response?.requestOptions.headers ?? "",
      'ERROR RESPONSE :': err.error,
      'ERROR RESPONSE MESSAGE':err.message,
    };
    logger.i(message);
    return super.onError(err, errorInterceptorHandler);
  }


}

