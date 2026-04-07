import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<TaskModel> _tasks = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isDarkMode = false;
  bool _isLoading = false;

  // Getters
  List<TaskModel> get tasks => _tasks;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Filter by category and search query
  List<TaskModel> get filteredTasks {
    List<TaskModel> result = _tasks;

    // Filter by category
    if (_selectedCategory != 'All') {
      result = result.where((task) => task.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
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

  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}