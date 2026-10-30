import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/repositories/task_repository.dart';
import 'package:path_finder/presentation/home/cubit/home_cubit.dart';
import 'package:path_finder/presentation/process/process_screen.dart';
import 'package:path_finder/presentation/widgets/app_loader.dart';
import 'package:path_finder/presentation/widgets/custom_appbar.dart';
import 'package:path_finder/presentation/widgets/custom_elevated_button.dart';
import 'package:path_finder/presentation/widgets/error_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.homeScreen),
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.tasks != current.tasks && current.tasks != null,
        listener: (context, state) {
          final tasks = state.tasks;
          if (tasks == null) {
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProcessScreen(
                apiUrl: state.url.trim(),
                tasks: tasks,
                taskRepository: context.read<TaskRepository>(),
              ),
            ),
          );
          context.read<HomeCubit>().consumeNavigation();
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(AppStrings.setValidApiUrl),
                        Row(
                          children: [
                            const Icon(
                              Icons.swap_horiz_sharp,
                              color: Color.fromARGB(255, 137, 137, 137),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                enabled: !state.isLoading,
                                decoration: const InputDecoration(
                                  hintText: AppStrings.urlHint,
                                  border: UnderlineInputBorder(),
                                ),
                                onChanged: context.read<HomeCubit>().onUrlChanged,
                              ),
                            ),
                          ],
                        ),
                        if (state.failure != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ErrorBanner(failure: state.failure!),
                          ),
                      ],
                    ),
                    CustomElevatedButton(
                      title: AppStrings.start,
                      onPressed: state.isLoading
                          ? null
                          : () => context.read<HomeCubit>().start(),
                    ),
                  ],
                ),
              ),
              if (state.isLoading) const AppLoader(),
            ],
          );
        },
      ),
    );
  }
}
