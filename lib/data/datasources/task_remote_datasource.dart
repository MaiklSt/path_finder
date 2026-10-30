import 'package:dio/dio.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/data/dto/result_payload_dto.dart';
import 'package:path_finder/data/dto/task_dto.dart';
import 'package:path_finder/data/models/test_result_response.dart';
import 'package:path_finder/domain/failures/app_failure.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TaskDto>> fetchTasks(String url) async {
    try {
      final response = await _dio.get(url);
      final parsed = TasksResponseDto.fromJson(_asMap(response.data));
      _ensureSuccess(parsed.error, parsed.message, response.statusCode);
      if (parsed.data.isEmpty) {
        throw const AppFailure(message: AppStrings.emptyTasks);
      }
      return parsed.data;
    } on AppFailure {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioError(error);
    } catch (_) {
      throw const AppFailure(message: AppStrings.unexpectedResponse);
    }
  }

  Future<TestResultResponse> sendResults({
    required String url,
    required List<ResultPayloadDto> results,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: [for (final result in results) result.toJson()],
      );
      final body = _asMap(response.data);
      _ensureSuccess(
        body['error'] as bool? ?? true,
        body['message'] as String? ?? AppStrings.unexpectedResponse,
        response.statusCode,
      );
      return TestResultResponse.fromJson(response.data);
    } on AppFailure {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioError(error);
    } catch (_) {
      throw const AppFailure(message: AppStrings.unexpectedResponse);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw const AppFailure(message: AppStrings.unexpectedResponse);
  }

  void _ensureSuccess(bool error, String message, int? statusCode) {
    if (error || statusCode != 200) {
      throw AppFailure(
        message: message.isEmpty ? AppStrings.unexpectedResponse : message,
        code: statusCode ?? 0,
      );
    }
  }

  AppFailure _mapDioError(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] is String) {
      return AppFailure(
        message: data['message'] as String,
        code: error.response?.statusCode ?? 0,
      );
    }
    return AppFailure(
      message: error.message ?? AppStrings.unexpectedResponse,
      code: error.response?.statusCode ?? 0,
    );
  }
}
