class Task {
  final String id;
  final String title;
  late bool completed;

  Task({required this.id, required this.title, required this.completed});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['_id'],
        title: json['description'],
        completed: json['completed']);
  }
}
