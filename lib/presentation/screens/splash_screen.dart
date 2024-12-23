import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/utils/assets_path.dart';
import 'package:task_manager/core/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  bool get _isLightTheme => Theme.of(context).brightness == Brightness.light;

  void _navigationToScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      if(!context.mounted) return;
      if(FirebaseAuth.instance.currentUser != null) {
        context.toNext(Screens.homeScreen);
      }else {
        context.toNext(Screens.loginScreen);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSurface, // navigation bar color
        statusBarColor: Theme.of(context).colorScheme.surface,
        statusBarBrightness: _isLightTheme ? Brightness.dark : Brightness.light
      ));
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);
    _navigationToScreen();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(_isLightTheme ? AssetsPath.lightLogo : AssetsPath.darkLogo),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: "Task Manger".split('').map((char) {
                  final index = "Task Manager".indexOf(char);
                  final yOffset = sin((_controller.value * 2 * pi) + (index * 0.5)) * 20;

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Text(
                      char,
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "pacifico",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
