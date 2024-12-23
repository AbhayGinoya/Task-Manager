import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/utils/app_colors.dart';
import 'package:task_manager/core/utils/app_sizes.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/core/utils/validation.dart';
import 'package:task_manager/data/models/pair.dart';
import 'package:task_manager/presentation/widgets/custom_buttons.dart';
import 'package:task_manager/presentation/widgets/custom_text_form_field.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);
  final ValueNotifier<bool> _isObserve = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rememberMe.dispose();
    _isObserve.dispose();
    _isLoading.dispose();
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
                    "Sign Up Here",
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
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
                  gapH12,
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
                              final auth = ref.read(authProvider.notifier);
                              final Pair<bool, String> response = await auth.register(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              if (!context.mounted) return;

                              if (response.first) {
                                context.toNext(Screens.homeScreen);
                                successSnackBar(context: context, message: response.second);
                              } else {
                                errorSnackBar(context: context, message: response.second);
                              }
                              _isLoading.value = false;
                            },
                            context: context,
                            buttonName: 'Sign Up',
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
                                  context.toNext(Screens.loginScreen);
                                },
                              text: "Already have an account?",
                              style: Theme.of(context).textTheme.bodyLarge),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.toNext(Screens.loginScreen);
                                },
                              text: "Login",
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
}
