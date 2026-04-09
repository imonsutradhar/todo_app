import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'add_task_screen.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          // Tap anywhere to dismiss keyboard
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
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
                : Column(
              children: [
                const SizedBox(height: 8),
                _buildProgressCard(context, provider),
                const SizedBox(height: 12),
                _buildSearchBar(context, provider),
                const SizedBox(height: 8),
                _buildCategoryChips(context, provider),
                const SizedBox(height: 8),
                Expanded(
                  child: provider.filteredTasks.isEmpty
                      ? _buildEmptyState(context)
                      : _buildTaskList(context, provider),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Task'),
            ),
          ),
        );
      },
    );
  }

  // Progress card with priority breakdown
  Widget _buildProgressCard(BuildContext context, TaskProvider provider) {
    final total = provider.tasks.length;
    final completed = provider.tasks.where((t) => t.isCompleted).length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$completed/$total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              total == 0
                  ? 'No tasks yet!'
                  : '${(progress * 100).toInt()}% completed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            // Priority breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriorityCount(
                  context,
                  'High',
                  provider.tasks
                      .where((t) => t.priority == Priority.high)
                      .length,
                  AppTheme.highPriority,
                ),
                _buildPriorityCount(
                  context,
                  'Medium',
                  provider.tasks
                      .where((t) => t.priority == Priority.medium)
                      .length,
                  AppTheme.mediumPriority,
                ),
                _buildPriorityCount(
                  context,
                  'Low',
                  provider.tasks
                      .where((t) => t.priority == Priority.low)
                      .length,
                  AppTheme.lowPriority,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Priority count widget
  Widget _buildPriorityCount(
      BuildContext context,
      String label,
      int count,
      Color color,
      ) {
    return Column(
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Search bar
  Widget _buildSearchBar(BuildContext context, TaskProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => provider.searchTasks(value),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: provider.searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => provider.searchTasks(''),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  // Category filter chips
  Widget _buildCategoryChips(BuildContext context, TaskProvider provider) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final isSelected = provider.selectedCategory == category;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => provider.setCategory(category),
            showCheckmark: false,
          );
        },
      ),
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
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // Task list
  Widget _buildTaskList(BuildContext context, TaskProvider provider) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.filteredTasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = provider.filteredTasks[index];
        return TaskCard(task: task);
      },
    );
  }
}