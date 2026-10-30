import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}
