import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class FirebaseService {
  // Firestore Auth instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Currently logged in user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // App open হলে anonymous login করে
  Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  // Firestore থেকে real-time tasks আনে (Stream মানে data change হলে auto update)
  Stream<List<TaskModel>> getTasksStream() {
    return _db
        .collection('tasks')                          // 'tasks' collection
        .where('userId', isEqualTo: currentUserId)    // শুধু এই user এর tasks
        .snapshots()                                   // real-time listen
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc))
        .toList());
  }

  //New Task
  Future<void> addTask(TaskModel task) async {
    await _db.collection('tasks').add(task.toFirestore());
  }

  // task update
  Future<void> updateTask(TaskModel task) async {
    await _db.collection('tasks').doc(task.id).update(task.toFirestore());
  }

  // task delete
  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }
}