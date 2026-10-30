import 'package:flutter/material.dart';
import 'package:path_finder/data/repositories/task_repository_impl.dart';
import 'package:path_finder/app.dart';
import 'package:path_finder/data/datasources/task_remote_datasource.dart';
import 'package:path_finder/data/network/dio_client.dart';

void main() {
  final repository = TaskRepositoryImpl(
    TaskRemoteDataSource(createDioClient()),
  );

  runApp(App(taskRepository: repository));
}
