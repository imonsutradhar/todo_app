# ✅ Task Manager App

A clean and modern task management app built with Flutter. Supports task creation, filtering, sorting, priority management, and dark mode — all with local state using Provider.

---

## 📱 Features

- **Add / Edit / Delete Tasks** — swipe left to delete, tap to edit
- **Priority Levels** — High 🔴, Medium 🟡, Low 🟢 with color indicators
- **Due Dates** — date picker with overdue highlighting
- **Category Filter** — filter tasks by custom categories
- **Search** — real-time search by task title
- **Sort** — sort by date, priority, or name
- **Progress Tracking** — progress card showing completion percentage
- **Dark Mode** — toggle between light and dark theme

---

## 🗂️ Project Structure

```
lib/
├── models/
│   └── task_model.dart         # TaskModel class & Priority enum
├── providers/
│   └── task_provider.dart      # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart        # Main screen
│   └── add_task_screen.dart    # Add / Edit task screen
├── widgets/
│   ├── task_card.dart          # Individual task card (swipe to delete)
│   ├── task_list.dart          # Filtered task list
│   ├── task_form_widgets.dart  # Category chips, priority selector etc.
│   ├── progress_card.dart      # Progress bar card
│   ├── category_chips.dart     # Horizontal category filter
│   ├── search_bar.dart         # Animated search bar
│   └── empty_state.dart        # Empty list placeholder
└── main.dart
```



## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/home.jpg" width="220"/>
  <img src="assets/screenshots/home_light.jpg" width="220"/>
</p>

<p align="center">
  <img src="assets/screenshots/new.jpg" width="220"/>
  <img src="assets/screenshots/edit.jpg" width="220"/>
</p>


