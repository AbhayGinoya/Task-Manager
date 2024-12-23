import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/presentation/screens/home_screen.dart';
import 'package:task_manager/presentation/screens/login_screen.dart';
import 'package:task_manager/presentation/screens/sign_up_screen.dart';
import 'package:task_manager/presentation/screens/splash_screen.dart';

abstract final class Routes {
  Routes._();

  static get routes => GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SplashScreen(),),
          GoRoute(path: Screens.loginScreen.screenName, builder: (context, state) => const LoginScreen(),),
          GoRoute(path: Screens.signUpScreen.screenName, builder: (context, state) => const SignUpScreen()),

          GoRoute(path: Screens.homeScreen.screenName, builder: (context, state) => const HomeScreen()),
        ],
      );
}

extension Navigation on BuildContext {
  void toNext(Screens screen, {bool closeScreen = false, dynamic argument}) {
    //String routePath = screen.map((e)=> e.screenName).join();
    go(screen.screenName, extra: argument);
  }

  void goBack({dynamic argument}) => GoRouter.of(this).pop(argument);
}

enum Screens {
  splashScreen("/"),
  loginScreen("/login"),
  signUpScreen("/signup"),
  homeScreen("/home");

  final String screenName;

  const Screens(this.screenName);
}
