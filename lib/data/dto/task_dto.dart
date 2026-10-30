import 'package:path_finder/domain/entities/grid_task.dart';
import 'package:path_finder/domain/entities/path_grid.dart';
import 'package:path_finder/domain/entities/point.dart';

class TaskDto {
  const TaskDto({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  final String id;
  final List<String> field;
  final PointDto start;
  final PointDto end;

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      field: List<String>.from(json['field'] as List),
      start: PointDto.fromJson(json['start'] as Map<String, dynamic>),
      end: PointDto.fromJson(json['end'] as Map<String, dynamic>),
    );
  }

  GridTask toDomain() {
    return GridTask(
      id: id,
      grid: PathGrid.fromField(field),
      start: start.toDomain(),
      end: end.toDomain(),
    );
  }
}

class PointDto {
  const PointDto({required this.x, required this.y});

  final int x;
  final int y;

  factory PointDto.fromJson(Map<String, dynamic> json) {
    return PointDto(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
    );
  }

  Point toDomain() => Point(x: x, y: y);
}

class TasksResponseDto {
  const TasksResponseDto({
    required this.error,
    required this.message,
    required this.data,
  });

  final bool error;
  final String message;
  final List<TaskDto> data;

  factory TasksResponseDto.fromJson(Map<String, dynamic> json) {
    return TasksResponseDto(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const []
          : List<TaskDto>.from(
              (json['data'] as List).map(
                (item) => TaskDto.fromJson(item as Map<String, dynamic>),
              ),
            ),
    );
  }
}
