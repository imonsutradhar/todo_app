import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskSearchBar extends StatefulWidget {
  const TaskSearchBar({super.key});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  final _controller = TextEditingController();
  bool _focused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focused
                ? const Color(0xFF6C63FF)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _focused
                  ? const Color(0xFF6C63FF).withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _focused ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: TextField(
            controller: _controller,
            onChanged: (val) => provider.searchTasks(val),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            ),
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: _focused
                    ? const Color(0xFF6C63FF)
                    : (isDark ? Colors.white30 : Colors.black38),
              ),
              suffixIcon: provider.searchQuery.isNotEmpty
                  ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  provider.searchTasks('');
                },
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: isDark ? Colors.white30 : Colors.black38,
                ),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}