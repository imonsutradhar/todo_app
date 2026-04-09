import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

enum SortBy { date, priority, name }

class TaskProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<TaskModel> _tasks = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortBy _sortBy = SortBy.date;
  bool _isDarkMode = false;
  bool _isLoading = false;

  // Getters
  List<TaskModel> get tasks => _tasks;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortBy get sortBy => _sortBy;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Filter by category, search query and sort
  List<TaskModel> get filteredTasks {
    List<TaskModel> result = _tasks;

    // Filter by category
    if (_selectedCategory != 'All') {
      result = result
          .where((task) => task.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort
    switch (_sortBy) {
      case SortBy.date:
        result.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortBy.priority:
        result.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortBy.name:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return result;
  }

  // All unique categories
  List<String> get categories {
    final cats = _tasks.map((t) => t.category).toSet().toList();
    return ['All', ...cats];
  }

  // Load real-time tasks from Firebase
  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    _firebaseService.getTasksStream().listen((tasks) {
      _tasks = tasks;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Add new task
  Future<void> addTask(TaskModel task) async {
    await _firebaseService.addTask(task);
  }

  // Toggle task complete/incomplete
  Future<void> toggleTaskComplete(TaskModel task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _firebaseService.updateTask(updated);
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    await _firebaseService.deleteTask(taskId);
  }

  // Update existing task
  Future<void> updateTask(TaskModel task) async {
    await _firebaseService.updateTask(task);
  }

  // Change category filter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search tasks by title
  void searchTasks(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Change sort order
  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}