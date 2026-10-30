part of 'process_cubit.dart';

class ProcessState {
  const ProcessState({
    this.isProcessing = true,
    this.progress = 0,
    this.isSending = false,
    this.failure,
    this.solutions = const [],
  });

  final bool isProcessing;
  final double progress;
  final bool isSending;
  final AppFailure? failure;
  final List<PathSolution> solutions;

  bool get canSend => !isProcessing && !isSending && solutions.isNotEmpty;

  ProcessState copyWith({
    bool? isProcessing,
    double? progress,
    bool? isSending,
    AppFailure? failure,
    List<PathSolution>? solutions,
    bool clearFailure = false,
  }) {
    return ProcessState(
      isProcessing: isProcessing ?? this.isProcessing,
      progress: progress ?? this.progress,
      isSending: isSending ?? this.isSending,
      failure: clearFailure ? null : failure ?? this.failure,
      solutions: solutions ?? this.solutions,
    );
  }
}
