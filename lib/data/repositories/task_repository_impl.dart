import 'package:path_finder/data/datasources/task_remote_datasource.dart';
import 'package:path_finder/data/dto/result_payload_dto.dart';
import 'package:path_finder/data/models/test_result_response.dart';
import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/entities/path_solution.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._remoteDataSource);

  final TaskRemoteDataSource _remoteDataSource;

  @override
  Future<List<GridTask>> fetchTasks(String url) async {
    final tasks = await _remoteDataSource.fetchTasks(url);
    return [for (final task in tasks) task.toDomain()];
  }

  @override
  Future<TestResultResponse> sendResults({
    required String url,
    required List<PathSolution> solutions,
  }) {
    return _remoteDataSource.sendResults(
      url: url,
      results: [
        for (final solution in solutions) ResultPayloadDto.fromSolution(solution),
      ],
    );
  }
}
