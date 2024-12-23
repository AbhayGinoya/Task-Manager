
import 'package:riverpod/riverpod.dart';
import 'package:task_manager/core/utils/enum.dart';

class StatusNotifier extends StateNotifier<Status> {
  StatusNotifier() : super(Status.all);

  void changeSelectedStatus({required Status newStatus}) {
    if (state != newStatus) {
      state = newStatus;
    }
  }
}
