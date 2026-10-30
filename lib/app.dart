import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';
import 'package:path_finder/presentation/home/cubit/home_cubit.dart';
import 'package:path_finder/presentation/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.taskRepository});

  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TaskRepository>.value(
      value: taskRepository,
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (_) => HomeCubit(taskRepository: taskRepository),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
