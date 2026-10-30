import 'package:path_finder/domain/entities/path_grid.dart';
import 'package:path_finder/domain/entities/point.dart';

class GridTask {
  const GridTask({
    required this.id,
    required this.grid,
    required this.start,
    required this.end,
  });

  final String id;
  final PathGrid grid;
  final Point start;
  final Point end;
}
