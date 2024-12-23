import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/core/utils/app_theme.dart';
import 'package:task_manager/providers/theme_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'domain/use_case/sync_manger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  /// Initialize WorkManger
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Task Manger',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: Routes.routes,
    );
  }
}
