
class TestResult {
  final String id;
  final bool correct;

  const TestResult({
    required this.id,
    required this.correct,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      correct: json['correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correct': correct,
    };
  }
}