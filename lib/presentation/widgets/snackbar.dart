import 'package:flutter/material.dart';

ScaffoldMessengerState errorSnackBar({required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height - 100), right: 16, left: 16),
        padding: const EdgeInsets.all(4.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        dismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onError),
        ),
      ),
    );
}

ScaffoldMessengerState successSnackBar({required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height - 100), right: 16, left: 16),
        padding: const EdgeInsets.all(8.0),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
}
