import 'package:path_finder/domain/entities/path_solution.dart';

class ResultPayloadDto {
  const ResultPayloadDto({
    required this.id,
    required this.steps,
    required this.path,
  });

  final String id;
  final List<Map<String, String>> steps;
  final String path;

  factory ResultPayloadDto.fromSolution(PathSolution solution) {
    return ResultPayloadDto(
      id: solution.task.id,
      steps: [
        for (final point in solution.steps)
          {
            'x': '${point.x}',
            'y': '${point.y}',
          },
      ],
      path: solution.apiPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'result': {
          'steps': steps,
          'path': path,
        },
      };
}
