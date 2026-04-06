import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/task_provider.dart';
import 'services/firebase_service.dart';
//import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensures Flutter is ready before running anything
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Notifications
  //await NotificationService.initialize();

  // Anonymous  login
  await FirebaseService().signInAnonymously();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider()..loadTasks(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'To Do App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen()
        );
      }
    );
  }
}
