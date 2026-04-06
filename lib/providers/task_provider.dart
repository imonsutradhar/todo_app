import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<TaskModel> _tasks = [];        // সব tasks
  String _selectedCategory = 'All';  // Selected category filter
  bool _isDarkMode = false;           // Dark mode on/off
  bool _isLoading = false;            // Loading indicator

  // Getters — Read data from outside
  List<TaskModel> get tasks => _tasks;
  String get selectedCategory => _selectedCategory;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // filtered tasks by selected category
  List<TaskModel> get filteredTasks {
    if (_selectedCategory == 'All') return _tasks;
    return _tasks.where((task) => task.category == _selectedCategory).toList();
  }

  //  unique categories
  List<String> get categories {
    final cats = _tasks.map((t) => t.category).toSet().toList();
    return ['All', ...cats];
  }

  //  real-time tasks load from FireBase
  void loadTasks() {
    _isLoading = true;
    notifyListeners(); // UI কে জানায় যে data loading হচ্ছে

    _firebaseService.getTasksStream().listen((tasks) {
      _tasks = tasks;
      _isLoading = false;
      notifyListeners(); //
    });
  }

  // new task add
  Future<void> addTask(TaskModel task) async {
    await _firebaseService.addTask(task);
  }

  // Task complete/incomplete toggle
  Future<void> toggleTaskComplete(TaskModel task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _firebaseService.updateTask(updated);
  }

  // Task delete
  Future<void> deleteTask(String taskId) async {
    await _firebaseService.deleteTask(taskId);
  }

  // Category filter change
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Dark mode toggle
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}