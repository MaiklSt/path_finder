import 'package:path_finder/data/models/test_result_response.dart';
import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/entities/path_solution.dart';

abstract class TaskRepository {
  Future<List<GridTask>> fetchTasks(String url);

  Future<TestResultResponse> sendResults({
    required String url,
    required List<PathSolution> solutions,
  });
}
