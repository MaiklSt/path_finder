import 'package:path_finder/domain/entities/point.dart';

class PathGrid {
  PathGrid._(this.cells);

  factory PathGrid.fromField(List<String> field) {
    if (field.isEmpty) {
      throw ArgumentError('Grid must not be empty');
    }

    final size = field.length;
    final cells = <List<bool>>[];

    for (final row in field) {
      if (row.length != size) {
        throw ArgumentError('Grid must be square');
      }
      cells.add([for (final cell in row.split('')) cell != 'X']);
    }

    return PathGrid._(cells);
  }

  /// `true` if the cell is walkable.
  final List<List<bool>> cells;

  int get size => cells.length;

  bool contains(Point point) =>
      point.x >= 0 && point.y >= 0 && point.x < size && point.y < size;

  bool isWalkable(Point point) => contains(point) && cells[point.y][point.x];

  bool isBlocked(Point point) => contains(point) && !cells[point.y][point.x];
}
