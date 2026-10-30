import 'package:flutter/material.dart';
import 'package:path_finder/core/app_strings.dart';
import 'package:path_finder/domain/failures/app_failure.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.failure});

  final AppFailure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red[200],
            borderRadius: BorderRadius.circular(12.5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppStrings.error}: code: ${failure.code}'),
              const SizedBox(height: 8),
              Text(failure.message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
