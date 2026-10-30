import 'package:flutter/material.dart';
import 'package:path_finder/presentation/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            return AppColors.button;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.5),
              side: const BorderSide(color: AppColors.buttonBorder),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
