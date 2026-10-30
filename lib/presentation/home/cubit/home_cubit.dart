import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/core/url_validator.dart';
import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/failures/app_failure.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required TaskRepository taskRepository,
    UrlValidator urlValidator = const UrlValidator(),
  })  : _taskRepository = taskRepository,
        _urlValidator = urlValidator,
        super(const HomeState());

  final TaskRepository _taskRepository;
  final UrlValidator _urlValidator;

  void onUrlChanged(String value) {
    emit(state.copyWith(url: value, clearFailure: true, clearTasks: true));
  }

  Future<void> start() async {
    final url = state.url.trim();
    if (!_urlValidator.isValid(url)) {
      emit(
        state.copyWith(
          failure: const AppFailure(message: AppStrings.invalidUrl),
          isLoading: false,
          clearTasks: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearFailure: true, clearTasks: true));

    try {
      final tasks = await _taskRepository.fetchTasks(url);
      emit(state.copyWith(isLoading: false, tasks: tasks));
    } on AppFailure catch (failure) {
      emit(state.copyWith(isLoading: false, failure: failure, clearTasks: true));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          failure: AppFailure(message: error.toString()),
          clearTasks: true,
        ),
      );
    }
  }

  void consumeNavigation() {
    emit(state.copyWith(clearTasks: true));
  }
}
