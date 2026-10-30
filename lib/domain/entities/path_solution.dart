import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/entities/point.dart';

class PathSolution {
  const PathSolution({
    required this.task,
    required this.steps,
    this.correct,
  });

  final GridTask task;
  final List<Point> steps;
  final bool? correct;

  String get displayPath => steps.map((point) => point.toDisplayString()).join(' -> ');

  String get apiPath => steps.map((point) => point.toApiString()).join('->');

  Set<Point> get pathCells => steps.toSet();

  bool get isCorrect => correct == true;

  PathSolution copyWith({
    GridTask? task,
    List<Point>? steps,
    bool? correct,
  }) {
    return PathSolution(
      task: task ?? this.task,
      steps: steps ?? this.steps,
      correct: correct ?? this.correct,
    );
  }
}
