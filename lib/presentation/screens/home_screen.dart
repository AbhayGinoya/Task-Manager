import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/utils/app_colors.dart';
import 'package:task_manager/core/utils/app_sizes.dart';
import 'package:task_manager/core/utils/enum.dart';
import 'package:task_manager/core/utils/extension.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/core/utils/validation.dart';
import 'package:task_manager/data/models/pair.dart';
import 'package:task_manager/domain/use_case/sync_manger.dart';
import 'package:task_manager/presentation/widgets/custom_buttons.dart';
import 'package:task_manager/presentation/widgets/custom_text_form_field.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Status> _statuses = [
    Status.all,
    Status.pending,
    Status.open,
    Status.completed,
    Status.cancel,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await SyncManager.syncServerToLocal();
      if (!context.mounted) return;
      final ref = ProviderScope.containerOf(context);
      ref.read(taskProvider.notifier).loadAllTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        actions: [
          IconButton(
            onPressed: () {
              //final themeNotifier = ref.read(themeNotifierProvider.notifier);
              //themeNotifier.toggleTheme();
            },
            icon: Icon(
                Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          ),
          Consumer(builder: (context, ref, _) {
            return PopupMenuButton<int>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
              onSelected: (value) async {
                if (value == 1) {
                  final auth = ref.read(authProvider.notifier);
                  final Pair<bool, String> response = await auth.logout();

                  if (!context.mounted) return;
                  if (response.first) {
                    successSnackBar(context: context, message: response.second);

                    context.toNext(Screens.loginScreen);
                  } else {
                    errorSnackBar(message: response.second, context: context);
                  }
                } else if (value == 2) {
                  _updateEmailPassword(context: context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [Icon(Icons.login), gapW8, Text("LogOut")],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [Icon(Icons.email), gapW4, Text("Update Email")],
                  ),
                ),
              ],
              elevation: 2,
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Center(
            child: Consumer(builder: (context, ref, _) {
              final statusNotifier = ref.read(statusProvider.notifier);
              final status = ref.watch(statusProvider);

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    borderColor: Theme.of(context).colorScheme.primary,
                    selectedBorderColor: Theme.of(context).colorScheme.tertiary,
                    borderWidth: 1,
                    borderRadius: BorderRadius.circular(Sizes.p8),
                    onPressed: (int index) {
                      statusNotifier.changeSelectedStatus(newStatus: _statuses[index]);
                    },
                    isSelected: List.generate(_statuses.length, (index) => _statuses[index] == status),
                    children: _statuses
                        .map((Status label) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(label.toString()),
                            ))
                        .toList(),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        final isLoading = ref.watch(taskProvider.notifier.select((state) => state.isLoading));
        final tasks = ref.watch(taskProvider);
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(Sizes.p8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.p4),
                        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1)),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      size: 32,
                    )),
                gapH8,
                Text(
                  "No tasks yet",
                  style:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                )
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8, vertical: Sizes.p8),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    /// Mark task as completed
                    ref
                        .read(taskProvider.notifier)
                        .updateStatus(serverId: task.serverId, id: task.id, status: Status.completed);
                  } else if (direction == DismissDirection.endToStart) {
                    /// Delete task
                    ref.read(taskProvider.notifier).deleteTask(serverId: task.serverId, task.id);
                  }
                },
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.task_alt_rounded,
                          color: Colors.white,
                        ),
                        gapW8,
                        Text(
                          "Completed",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white),
                        )
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      if(task.status == Status.pending.toString()) {
                        _createNewTaskDialog(
                            context: context,
                            title: task.title,
                            description: task.description,
                            taskId: task.id,
                            serverId: task.serverId);
                      }
                    },
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    leading: const Icon(Icons.task_alt_rounded),
                    title: Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        gapH4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PopupMenuButton<Status>(
                                padding: EdgeInsets.zero,
                                tooltip: "Tap to change status",
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Status.find(task.status),
                                  ),
                                  child: Text(
                                    task.status,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                                  ),
                                ),
                                onSelected: (Status status) {
                                  /// Change task status to selected status
                                  ref
                                      .read(taskProvider.notifier)
                                      .updateStatus(serverId: task.serverId, id: task.id, status: status);
                                },
                                itemBuilder: (context) => _statuses
                                    .where((element) => element != Status.all)
                                    .map(
                                      (e) => PopupMenuItem(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList()),
                            const Spacer(),
                            Container(
                                padding: const EdgeInsets.all(Sizes.p4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Sizes.p4),
                                    color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1)),
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            gapW4,
                            Text(
                              task.date.formatDate(DateFormats.MMM_DD_HH_MM_AA),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.primary, letterSpacing: 0.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewTaskDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Add Task Dialog
  Future _createNewTaskDialog(
      {required BuildContext context, String title = "", String description = "", int? taskId, String? serverId}) {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController descriptionController = TextEditingController(text: description);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.p8)),
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_task_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            gapW8,
                            Text(
                              taskId != null ? "Edit Task" : "Create New Task",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      gapH24,
                      AppTextFormFiled(
                        controller: titleController,
                        labelText: "Title",
                        keyboardType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        validation: (value) => Validation.titleValidation(value).second,
                      ),
                      gapH16,
                      AppTextFormFiled(
                        controller: descriptionController,
                        labelText: "Description",
                        keyboardType: TextInputType.multiline,
                        inputAction: TextInputAction.newline,
                        minLine: 1,
                        maxLine: 4,
                        validation: (value) => Validation.descriptionValidation(value).second,
                      ),
                      gapH24,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtons.outLineButton(
                                onPressed: () {
                                  GoRouter.of(context).pop();
                                },
                                buttonName: "Cancel",
                                context: context,
                                buttonModifier: const ButtonModifier(width: 0, height: 40)),
                            gapW8,
                            Consumer(builder: (context, ref, _) {
                              return CustomButtons.fillButton(
                                  onPressed: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    FocusScope.of(context).unfocus();
                                    final task = ref.read(taskProvider.notifier);

                                    if (taskId != null && (title.isNotEmpty || description.isNotEmpty)) {
                                      /// Update Old task
                                      task.updateTask(
                                          serverId: serverId,
                                          taskId: taskId,
                                          title: titleController.text,
                                          description: descriptionController.text);
                                    } else {
                                      /// Add New Task
                                      task.createTask(
                                          title: titleController.text, description: descriptionController.text);
                                    }
                                    GoRouter.of(context).pop();
                                  },
                                  buttonName: taskId != null ? "Edit Task" : "Create Task",
                                  context: context,
                                  buttonModifier: const ButtonModifier(width: 0, height: 40));
                            }),
                          ],
                        ),
                      ),
                      gapH4,
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Update Email Dialog
  Future _updateEmailPassword({required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      gapH16,
                      Text(
                        "Email Update",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                      ),
                      gapH24,
                      AppTextFormFiled(
                        controller: emailController,
                        labelText: "New Email",
                        keyboardType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        validation: (value) => Validation.emailValidation(value).second,
                      ),
                      gapH16,
                      AppTextFormFiled(
                        controller: passwordController,
                        labelText: "Current Password",
                        keyboardType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        validation: (value) => Validation.passwordValidation(value).second,
                      ),
                      gapH24,
                      Consumer(builder: (context, ref, _) {
                        return CustomButtons.fillButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              FocusScope.of(context).unfocus();

                              setState(() {
                                isLoading = true;
                              });
                              final auth = ref.read(authProvider.notifier);

                              final Pair<bool, String> result = await auth.updateEmail(
                                  email: emailController.text, password: passwordController.text);
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
                            buttonName: "Update",
                            context: context,
                            isLoading: isLoading);
                      }),
                      gapH16,
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
