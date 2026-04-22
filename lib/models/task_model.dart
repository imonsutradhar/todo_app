enum Priority { high, medium, low }

class TaskModel {
  final String id;
  final String title;
  final String category;
  final Priority priority;
  final DateTime? dueDate;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? title,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}