
class TaskEntity {
  final int id;
  final String? serverId;
  final String userId;
  final String title;
  final String description;
  final String status;
  final DateTime date;

  TaskEntity({required this.id, this.serverId, required this.userId,required this.title, required this.description, required this.status, required this.date});
}

