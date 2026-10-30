import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/pathfinding/shortest_path_finder.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';
import 'package:path_finder/presentation/process/cubit/process_cubit.dart';
import 'package:path_finder/presentation/result/result_list_screen.dart';
import 'package:path_finder/presentation/widgets/app_loader.dart';
import 'package:path_finder/presentation/widgets/custom_appbar.dart';
import 'package:path_finder/presentation/widgets/custom_elevated_button.dart';
import 'package:path_finder/presentation/widgets/error_banner.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({
    super.key,
    required this.apiUrl,
    required this.tasks,
    required this.taskRepository,
  });

  final String apiUrl;
  final List<GridTask> tasks;
  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProcessCubit(
        taskRepository: taskRepository,
        pathFinder: ShortestPathFinder(),
        apiUrl: apiUrl,
        tasks: tasks,
      )..calculate(),
      child: const _ProcessView(),
    );
  }
}

class _ProcessView extends StatelessWidget {
  const _ProcessView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.processScreen),
      body: BlocBuilder<ProcessCubit, ProcessState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                if (state.failure != null && !state.isSending)
                  ErrorBanner(failure: state.failure!)
                else
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                        child: Text(
                          state.isSending
                              ? AppStrings.sending
                              : state.isProcessing
                                  ? AppStrings.calculating
                                  : AppStrings.calculationsFinished,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (state.isSending)
                        const AppLoader()
                      else
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: state.progress,
                              ),
                            ),
                            Text(
                              '${(state.progress * 100).round()}%',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                    ],
                  ),
                CustomElevatedButton(
                  title: AppStrings.sendResultsToServer,
                  onPressed: state.canSend
                      ? () async {
                          final navigator = Navigator.of(context);
                          final cubit = context.read<ProcessCubit>();
                          final sent = await cubit.sendResults();
                          if (sent) {
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => ResultListScreen(
                                  solutions: cubit.state.solutions,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
