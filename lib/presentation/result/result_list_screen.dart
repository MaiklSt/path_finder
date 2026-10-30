import 'package:flutter/material.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/entities/path_solution.dart';
import 'package:path_finder/presentation/preview/preview_screen.dart';
import 'package:path_finder/presentation/widgets/custom_appbar.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key, required this.solutions});

  final List<PathSolution> solutions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.resultListScreen),
      body: ListView.separated(
        itemCount: solutions.length,
        itemBuilder: (context, index) {
          final solution = solutions[index];
          return ListTile(
            title: Text(
              '${solution.displayPath} // result - (${solution.correct})',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PreviewScreen(solution: solution),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 1),
      ),
    );
  }
}
