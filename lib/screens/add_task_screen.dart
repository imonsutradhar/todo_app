import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  final _descController = TextEditingController();
  Priority _priority = Priority.medium;
  DateTime? _dueDate;
  bool get _isEdit => widget.task != null;

  static const _accent = Color(0xFF6C63FF);
  static const _priorityConfig = {
    Priority.high:   (label: 'High',   color: Color(0xFFEF4444), icon: Icons.local_fire_department_rounded),
    Priority.medium: (label: 'Medium', color: Color(0xFFF59E0B), icon: Icons.trending_flat_rounded),
    Priority.low:    (label: 'Low',    color: Color(0xFF22C55E), icon: Icons.south_rounded),
  };

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _titleController.text = widget.task!.title;
      _categoryController.text = widget.task!.category;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _accent, onPrimary: Colors.white,
            surface: Color(0xFF1E1E2E), onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please enter a task title'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    final provider = context.read<TaskProvider>();
    if (_isEdit) {
      provider.updateTask(widget.task!.copyWith(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      ));
    } else {
      provider.addTask(TaskModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      ));
    }
    Navigator.pop(context);
  }

  String _formatDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final diff = d.difference(DateTime.now()).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F14) : const Color(0xFFF5F5FA);
    final card = isDark ? const Color(0xFF1A1A2A) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.black.withOpacity(0.08);
    final hint = isDark ? Colors.white24 : Colors.black26;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    InputDecoration fieldDecor(String hintText, {IconData? icon}) => InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 14, color: hint),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: hint) : null,
      filled: true, fillColor: card,
      contentPadding: EdgeInsets.symmetric(horizontal: icon != null ? 0 : 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _accent, width: 1.5)),
    );

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.6, color: isDark ? Colors.white54 : Colors.black45)),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, centerTitle: true,
        title: Text(_isEdit ? 'Edit Task' : 'New Task',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_rounded, size: 16, color: isDark ? Colors.white70 : Colors.black54),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label('Task Title'),
            TextField(controller: _titleController, autofocus: true, maxLines: 1,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: fieldDecor('What needs to be done?', icon: Icons.check_circle_outline_rounded)),

            const SizedBox(height: 20),
            label('Description'),
            TextField(controller: _descController, maxLines: 4,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: fieldDecor('Add notes or details...')),

            const SizedBox(height: 20),
            label('Category'),
            TextField(controller: _categoryController, maxLines: 1,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: fieldDecor('e.g. Work, Personal', icon: Icons.label_outline_rounded)),

            const SizedBox(height: 20),
            label('Priority'),
            const SizedBox(height: 2),
            Row(
              children: Priority.values.map((p) {
                final cfg = _priorityConfig[p]!;
                final sel = _priority == p;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: p == Priority.low ? 0 : 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: sel ? cfg.color.withOpacity(isDark ? 0.2 : 0.12) : card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: sel ? cfg.color.withOpacity(0.6) : border, width: sel ? 1.5 : 1),
                          boxShadow: sel ? [BoxShadow(color: cfg.color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
                        ),
                        child: Column(children: [
                          Icon(cfg.icon, size: 20, color: sel ? cfg.color : hint),
                          const SizedBox(height: 4),
                          Text(cfg.label, style: TextStyle(fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w400, color: sel ? cfg.color : hint)),
                        ]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            label('Due Date'),
            GestureDetector(
              onTap: _pickDate,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _dueDate != null ? _accent.withOpacity(isDark ? 0.15 : 0.08) : card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _dueDate != null ? _accent.withOpacity(0.4) : border, width: _dueDate != null ? 1.5 : 1),
                ),
                child: Row(children: [
                  Icon(Icons.calendar_today_rounded, size: 18, color: _dueDate != null ? _accent : hint),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    _dueDate != null ? _formatDate(_dueDate!) : 'Select a due date',
                    style: TextStyle(fontSize: 14, fontWeight: _dueDate != null ? FontWeight.w600 : FontWeight.w400, color: _dueDate != null ? _accent : hint),
                  )),
                  if (_dueDate != null)
                    GestureDetector(onTap: () => setState(() => _dueDate = null),
                        child: Icon(Icons.close_rounded, size: 16, color: _accent.withOpacity(0.6))),
                ]),
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent, foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(_isEdit ? Icons.save_rounded : Icons.add_task_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(_isEdit ? 'Save Changes' : 'Create Task',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}