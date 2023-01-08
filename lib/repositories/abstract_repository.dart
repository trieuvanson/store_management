import 'package:dio/dio.dart';

import '../constants/env.dart' as env;
import '../network/interceptor.dart';

abstract class AbstractRepository {
  late Dio _dio;
  late String baseURL;

  AbstractRepository() {
    BaseOptions options = BaseOptions(
      receiveTimeout: 15000,
      connectTimeout: 20000,
    );

    _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
    baseURL = env.baseUrl!;
  }

  Future<Response> get(
      {required String url,
      String? token,
      String? finalUrl,
      Map<String, dynamic>? queryParameters,
      int? branchId}) async {
    final String _url = finalUrl ?? baseURL;
    try {
      return await _dio.get(
        _url + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) "Authorization": "Bearer $token",
            if (branchId != null) "BranchId": branchId,
          },
        ),
        queryParameters: queryParameters,
      );
    } on DioError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      {required String url,
      String? finalUrl,
      dynamic data,
      String? token,
      int? branchId}) async {
    final String _url = finalUrl ?? baseURL;
    try {
      return await _dio.post(
        _url + url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) "Authorization": "Bearer $token",
            if (branchId != null) "BranchId": branchId,
          },
        ),
      );
    } on DioError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      {required String url,
      String? finalUrl,
      dynamic data,
      String? token,
      int? branchId}) async {
    final String _url = finalUrl ?? baseURL;
    try {
      return await _dio.put(
        _url + url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) "Authorization": "Bearer $token",
            if (branchId != null) "BranchId": branchId,
          },
        ),
      );
    } on DioError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteHttp(
      {required String url,
      String? finalUrl,
      String? token,
      int? branchId}) async {
    final String _url = finalUrl ?? baseURL;
    try {
      return await _dio.delete(
        (_url + url),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) "Authorization": "Bearer $token",
            if (branchId != null) "BranchId": branchId,
          },
        ),
      );
    } on DioError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
