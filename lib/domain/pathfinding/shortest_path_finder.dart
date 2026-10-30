import 'dart:collection';

import 'package:path_finder/domain/entities/path_grid.dart';
import 'package:path_finder/domain/entities/point.dart';

class ShortestPathFinder {
  static const List<Point> _directions = [
    Point(x: -1, y: -1),
    Point(x: 0, y: -1),
    Point(x: 1, y: -1),
    Point(x: -1, y: 0),
    Point(x: 1, y: 0),
    Point(x: -1, y: 1),
    Point(x: 0, y: 1),
    Point(x: 1, y: 1),
  ];

  List<Point> find({
    required PathGrid grid,
    required Point start,
    required Point end,
  }) {
    if (!grid.isWalkable(start) || !grid.isWalkable(end)) {
      throw StateError('Start and end cells must be walkable');
    }

    if (start == end) {
      return [start];
    }

    final visited = List.generate(
      grid.size,
      (_) => List<bool>.filled(grid.size, false),
    );
    final parent = <Point, Point>{};
    final queue = Queue<Point>()..add(start);
    visited[start.y][start.x] = true;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == end) {
        return _rebuildPath(parent: parent, start: start, end: end);
      }

      for (final direction in _directions) {
        final next = current + direction;
        if (!grid.isWalkable(next) || visited[next.y][next.x]) {
          continue;
        }
        visited[next.y][next.x] = true;
        parent[next] = current;
        queue.add(next);
      }
    }

    throw StateError('Path from $start to $end was not found');
  }

  List<Point> _rebuildPath({
    required Map<Point, Point> parent,
    required Point start,
    required Point end,
  }) {
    final path = <Point>[end];
    var current = end;
    while (current != start) {
      current = parent[current]!;
      path.add(current);
    }
    return path.reversed.toList();
  }
}
