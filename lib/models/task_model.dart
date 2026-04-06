import 'package:cloud_firestore/cloud_firestore.dart';

// Task priority
enum Priority { high, medium, low }

class TaskModel {

  final String id;
  final String title;
  final String description;
  final String category;
  final Priority priority;
  final DateTime? dueDate;
  final bool isCompleted;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
    required this.userId,
  });

  // Firestore document to TaskModel object
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      priority: Priority.values.firstWhere(
            (e) => e.name == data['priority'],
        orElse: () => Priority.medium,
      ),
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      isCompleted: data['isCompleted'] ?? false,
      userId: data['userId'] ?? '',
    );
  }

  // TaskModel object কে Firestore এ save করার জন্য Map এ convert করে
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority.name,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  // After updating the field return new object

  TaskModel copyWith({
    String? title,
    String? description,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId,
    );
  }
}