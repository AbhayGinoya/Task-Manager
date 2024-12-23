import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/utils/app_colors.dart';
import 'package:task_manager/core/utils/app_sizes.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/core/utils/validation.dart';
import 'package:task_manager/data/models/pair.dart';
import 'package:task_manager/domain/preference/auth_preference.dart';
import 'package:task_manager/presentation/widgets/custom_buttons.dart';
import 'package:task_manager/presentation/widgets/custom_text_form_field.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);
  final ValueNotifier<bool> _isObserve = ValueNotifier(true);

  /// Check Is Remember Me Or Not
  /// If Is True Whenever User Log Out Fill Email and Password Automatic
  /// else Set Empty Value in Email and Password
  Future<void> _checkIsRememberMeOrNot() async {
    AuthPreference userPreference = AuthPreference();

    bool isRemember = await userPreference.checkIsRememberMe();

    if (isRemember) {
      _emailController.text = await userPreference.getUserEmail();
      _passwordController.text = await userPreference.getUserPassword();
      _rememberMe.value = isRemember;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIsRememberMeOrNot();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
    _isObserve.dispose();
    _rememberMe.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(Sizes.p16),
          padding: const EdgeInsets.all(Sizes.p16),
          decoration:
              BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(Sizes.p16), boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              blurRadius: 20.0,
            ),
          ]),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login Here",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                  ),
                  gapH24,
                  AppTextFormFiled(
                    controller: _emailController,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    validation: (value) => Validation.emailValidation(value).second,
                  ),
                  gapH16,
                  ValueListenableBuilder(
                      valueListenable: _isObserve,
                      builder: (context, isObserve, _) {
                        return AppTextFormFiled(
                          controller: _passwordController,
                          isObserve: isObserve,
                          keyboardType: TextInputType.text,
                          validation: (value) => Validation.passwordValidation(value).second,
                          inputAction: TextInputAction.done,
                          labelText: "Password",
                          suffix: IconButton(
                            onPressed: () {
                              _isObserve.value = !_isObserve.value;
                            },
                            icon: Icon(!isObserve ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
                          ),
                        );
                      }),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButtons.textButton(
                      onPressed: () {
                        _forgotPasswordDialog();
                      },
                      buttonName: "Forgot Password",
                      context: context,
                      textColor: Colors.grey,
                    ),
                  ),
                  gapH8,
                  ValueListenableBuilder(
                      valueListenable: _rememberMe,
                      builder: (context, rememberMe, _) {
                        return CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: rememberMe,
                          onChanged: (value) => _rememberMe.value = value!,
                          title: Text(
                            "Remember Me",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        );
                      }),
                  gapH24,
                  ValueListenableBuilder(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, _) {
                        return Consumer(builder: (context, ref, child) {
                          return CustomButtons.fillButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _isLoading.value = true;
                              if(_rememberMe.value) {
                                AuthPreference authPreference = AuthPreference();
                                await authPreference.saveUserEmail(_emailController.text);
                                await authPreference.saveUserPassword(_passwordController.text);
                                await authPreference.saveIsRememberMe(_rememberMe.value);
                              }

                              final auth = ref.read(authProvider.notifier);
                              final Pair<bool, String> response = await auth.login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              if (!context.mounted) return;

                              if (response.first) {
                                successSnackBar(context: context, message: response.second);
                                context.toNext(Screens.homeScreen);
                              } else {
                                errorSnackBar(context: context, message: response.second);
                              }
                              _isLoading.value = false;
                            },
                            context: context,
                            buttonName: 'Login',
                            isLoading: isLoading,
                          );
                        });
                      }),
                  gapH16,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.toNext(Screens.signUpScreen);
                                },
                              text: "Don't have an account?",
                              style: Theme.of(context).textTheme.bodyLarge),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.toNext(Screens.signUpScreen);
                                },
                              text: "Sign Up",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Theme.of(context).colorScheme.primary, letterSpacing: 0.0))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _forgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    bool isLoading = false;

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    gapH16,
                    Text(
                      "Forgot Password",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                    ),
                    gapH24,
                    AppTextFormFiled(
                      controller: emailController,
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                      validation: (value) => Validation.emailValidation(value).second,
                    ),
                    gapH24,
                    Consumer(builder: (context, ref, _) {
                      return CustomButtons.fillButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              isLoading = true;
                            });
                            final auth = ref.read(authProvider.notifier);

                            final Pair<bool, String> result = await auth.forgotPassword(email: emailController.text);
                            if (!context.mounted) return;
                            if (result.first) {
                              successSnackBar(context: context, message: result.second);
                              GoRouter.of(context).pop();
                            } else {
                              errorSnackBar(context: context, message: result.second);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          buttonName: "Forgot",
                          context: context,
                          isLoading: isLoading);
                    }),
                    gapH16,
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
