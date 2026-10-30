import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/entities/path_solution.dart';
import 'package:path_finder/domain/failures/app_failure.dart';
import 'package:path_finder/domain/pathfinding/shortest_path_finder.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';

part 'process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit({
    required TaskRepository taskRepository,
    required ShortestPathFinder pathFinder,
    required this.apiUrl,
    required this.tasks,
  })  : _taskRepository = taskRepository,
        _pathFinder = pathFinder,
        super(const ProcessState());

  final TaskRepository _taskRepository;
  final ShortestPathFinder _pathFinder;
  final String apiUrl;
  final List<GridTask> tasks;

  Future<void> calculate() async {
    emit(const ProcessState());

    try {
      final solutions = <PathSolution>[];
      for (var index = 0; index < tasks.length; index++) {
        final task = tasks[index];
        final steps = _pathFinder.find(
          grid: task.grid,
          start: task.start,
          end: task.end,
        );
        solutions.add(PathSolution(task: task, steps: steps));
        emit(
          state.copyWith(
            progress: (index + 1) / tasks.length,
            solutions: List<PathSolution>.from(solutions),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }

      emit(state.copyWith(isProcessing: false, progress: 1));
    } catch (error) {
      emit(
        state.copyWith(
          isProcessing: false,
          failure: AppFailure(message: error.toString()),
        ),
      );
    }
  }

  Future<bool> sendResults() async {
    emit(state.copyWith(isSending: true, clearFailure: true));
    try {
      final response = await _taskRepository.sendResults(
        url: apiUrl,
        solutions: state.solutions,
      );

      final resultsById = {
        for (final result in response.data) result.id: result.correct,
      };

      final updatedSolutions = state.solutions.map((solution) {
        return solution.copyWith(
          correct: resultsById[solution.task.id],
        );
      }).toList();

      emit(
        state.copyWith(
          isSending: false,
          solutions: updatedSolutions,
        ),
      );

      return true;
    } on AppFailure catch (failure) {
      emit(state.copyWith(isSending: false, failure: failure));
      return false;
    } catch (error) {
      emit(
        state.copyWith(
          isSending: false,
          failure: AppFailure(message: error.toString()),
        ),
      );
      return false;
    }
  }
}
