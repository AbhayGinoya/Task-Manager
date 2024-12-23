import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/utils/app_colors.dart';

class AppTextFormFiled extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final String? Function(String? value)? validation;
  final Function(String? value)? onFiledSubmit;
  final ValueChanged<String>? onChange;
  final VoidCallback? onTap;
  final int maxLine;
  final int minLine;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final bool isObserve;
  final bool isReadOnly;

  const AppTextFormFiled(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.keyboardType,
      required this.inputAction,
      this.validation,
      this.onFiledSubmit,
      this.onChange,
      this.onTap,
      this.prefix,
      this.suffix,
      this.inputFormatters,
      this.isObserve = false,
      this.maxLine = 1,
      this.minLine = 1,
      this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      obscureText: isObserve,
      maxLines: maxLine,
      minLines: minLine,
      inputFormatters: inputFormatters ?? const [],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap,
      validator: validation,
      onFieldSubmitted: onFiledSubmit,
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: AppColors.white,
        filled: true,
        labelText: labelText,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
