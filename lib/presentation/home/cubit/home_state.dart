part of 'home_cubit.dart';

class HomeState {
  const HomeState({
    this.url = '',
    this.isLoading = false,
    this.failure,
    this.tasks,
  });

  final String url;
  final bool isLoading;
  final AppFailure? failure;
  final List<GridTask>? tasks;

  HomeState copyWith({
    String? url,
    bool? isLoading,
    AppFailure? failure,
    List<GridTask>? tasks,
    bool clearFailure = false,
    bool clearTasks = false,
  }) {
    return HomeState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : failure ?? this.failure,
      tasks: clearTasks ? null : tasks ?? this.tasks,
    );
  }
}
