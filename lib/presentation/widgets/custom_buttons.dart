
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/app_colors.dart';

class CustomButtons {
  ///  Background Fill Color
  static Widget fillButton(
      {required VoidCallback onPressed,
        required String buttonName,
        required BuildContext context,
        ButtonModifier buttonModifier = const ButtonModifier(),
        bool isLoading = false}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      height: buttonModifier.height,
      minWidth: buttonModifier.width,
      color: buttonModifier.buttonColor ?? Theme.of(context).colorScheme.primary,
      onPressed: () {
        if (!isLoading) onPressed();
      },
      child: isLoading
          ? const CircularProgressIndicator(
        color: AppColors.white,
      )
          : Text(
        buttonName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white),
      ),
    );
  }

  /// OutLine Button
  static Widget outLineButton(
      {required VoidCallback onPressed,
        required String buttonName,
        required BuildContext context,
        ButtonModifier buttonModifier = const ButtonModifier(),
        bool isLoading = false}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), side: BorderSide(color: Theme.of(context).colorScheme.primary)),
      height: buttonModifier.height,
      minWidth: buttonModifier.width,
      // color: buttonModifier.buttonColor,
      onPressed: () {
        if (!isLoading) onPressed();
      },
      child: isLoading
          ? const CircularProgressIndicator(
        color: AppColors.white,
      )
          : Text(
        buttonName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
      ),
    );
  }

  /// Text Button
  static Widget textButton({
    required VoidCallback onPressed,
    required String buttonName,
    required BuildContext context,
    Color? textColor,
    double horizontalPadding = 4.0,
    double verticalPadding = 0.0,
    double verticalDestiny = 0.0,
  }) {
    return CupertinoButton(
      onPressed: () => onPressed(),
      child: Text(
        buttonName,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor ?? Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
      ),
    );
  }


}

class ButtonModifier {
  final double height;
  final double width;
  final Color? buttonColor;

  const ButtonModifier({this.width = double.infinity, this.height = 50, this.buttonColor});
}
