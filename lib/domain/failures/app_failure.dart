class AppFailure implements Exception {
  const AppFailure({
    required this.message,
    this.code = 0,
  });

  final String message;
  final int code;

  @override
  String toString() => message;
}
