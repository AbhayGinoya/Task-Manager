class FirestoreTaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String date;

  FirestoreTaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.date,
  });

  factory FirestoreTaskModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FirestoreTaskModel(
      id: id,
      title: data['title'] as String,
      description: data['description'] as String?,
      status: data['status'] as String,
      date: data['date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, status: 'status','date':date};
  }
}
