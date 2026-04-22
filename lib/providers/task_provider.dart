import 'package:flutter/material.dart';
import '../models/task_model.dart';

enum SortBy { date, priority, name }

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortBy _sortBy = SortBy.date;
  bool _isDarkMode = false;

  //getters
  List<TaskModel> get tasks => _tasks;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortBy get sortBy => _sortBy;
  bool get isDarkMode => _isDarkMode;

  //filter by category
  List<TaskModel> get filteredTasks {
    List<TaskModel> result = _tasks;

    if (_selectedCategory != 'All') {
      result = result.where((task) => task.category == _selectedCategory).toList();
    }

    //search filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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

  //categories
  List<String> get categories {
    final cats = _tasks.map((t) => t.category).toSet().toList();
    return ['All', ...cats];
  }


  //add task
  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  // toggle complete
  void toggleTaskComplete(TaskModel task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  //delete task
  void deleteTask (String taskId) {
    tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  //update task
  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  //category filter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  //search tasks by title
  void searchTasks(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  //change sort order
  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  //dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}