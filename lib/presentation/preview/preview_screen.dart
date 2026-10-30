import 'package:flutter/material.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/entities/path_solution.dart';
import 'package:path_finder/domain/entities/point.dart';
import 'package:path_finder/presentation/theme/app_colors.dart';
import 'package:path_finder/presentation/widgets/custom_appbar.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.solution});

  final PathSolution solution;

  @override
  Widget build(BuildContext context) {
    final grid = solution.task.grid;
    final pathCells = solution.pathCells;

    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.previewScreen),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: grid.size,
                  ),
                  itemCount: grid.size * grid.size,
                  itemBuilder: (context, index) {
                    final point = Point(
                      x: index % grid.size,
                      y: index ~/ grid.size,
                    );
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: _cellColor(point, pathCells),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          '${point.x}.${point.y}',
                          style: TextStyle(
                            color: grid.isBlocked(point) ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                solution.displayPath,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _cellColor(Point point, Set<Point> pathCells) {
    if (point == solution.task.start) {
      return AppColors.startCell;
    }
    if (point == solution.task.end) {
      return AppColors.endCell;
    }
    if (pathCells.contains(point)) {
      return AppColors.pathCell;
    }
    if (solution.task.grid.isBlocked(point)) {
      return AppColors.blockedCell;
    }
    return AppColors.emptyCell;
  }
}
