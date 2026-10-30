import 'package:path_finder/data/models/test_result.dart';

class TestResultResponse {
  final bool error;
  final String message;
  final List<TestResult> data;

  const TestResultResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory TestResultResponse.fromJson(Map<String, dynamic> json) {
    return TestResultResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => TestResult.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}