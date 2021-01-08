class Todo {
  final int userId;
  final int id;
  final String title;
  final String completed;

  Todo({this.id, this.completed, this.title, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': title,
    };
  }
}
