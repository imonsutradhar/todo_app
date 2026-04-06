import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Tasks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${provider.filteredTasks.length} tasks',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            actions: [
              // Dark mode toggle button
              IconButton(
                icon: Icon(
                  provider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: provider.toggleDarkMode,
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.filteredTasks.isEmpty
              ? _buildEmptyState(context)
              : _buildTaskList(context, provider),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Add task screen - later
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Task'),
          ),
        );
      },
    );
  }

  // Empty state when no tasks
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add new task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
}

// Task List
  Widget _buildTaskList(BuildContext context, TaskProvider provider) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.filteredTasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = provider.filteredTasks[index];
        return Text(task.title); // Temporary, later TaskCard widget
      },
    );
  }
}