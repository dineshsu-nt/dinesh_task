import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinesh_project/models/task_model.dart';
import 'package:dinesh_project/models/user_model.dart';
import 'package:dinesh_project/repository/app_repo.dart';
import 'package:flutter/material.dart';

class UserRepo {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> uploadUserData(UserModel user) async {
    try {
      final userJson = user.toJson();

      await _usersCollection.doc(AppRepo().uid).set(userJson);
    } catch (e) {
      debugPrint('Error uploading user data to Firebase: $e');
    }
  }

  Future<void> uploadTask(TaskModel task, String docId) async {
    try {
      final userJson = task.toJson();

      await _usersCollection
          .doc(AppRepo().uid)
          .collection("task")
          .doc(docId)
          .set(userJson);
    } catch (e) {
      debugPrint('Error uploading task to Firebase: $e');
    }
  }

  Future<void> updateTask(TaskModel task, String docId) async {
    try {
      final userJson = task.toJson();

      await _usersCollection
          .doc(AppRepo().uid)
          .collection("task")
          .doc(docId)
          .update(userJson);
    } catch (e) {
      debugPrint('Error uploading task to Firebase: $e');
    }
  }

  Future<List<TaskModel>> fetchTaskData() async {
    try {
      final querySnapshot =
          await _usersCollection.doc(AppRepo().uid).collection('task').get();

      final taskList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TaskModel.fromJson(data);
      }).toList();

      return taskList;
    } catch (e) {
      debugPrint('Error fetching task data from Firebase: $e');
      return [];
    }
  }

  Future<List<UserModel>> fetchUserData() async {
    try {
      final documentSnapshot = await _usersCollection.doc( AppRepo().uid).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>? ?? {};
        final user = UserModel.fromJson(data);
        return [user];
      } else {
        return []; // Document not found
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return [];
    }
  }
  Future<void> updateProfileData(UserModel user) async {
    try {
      final userJson = user.toMap();

      await _usersCollection.doc(AppRepo().uid).update(userJson);
    } catch (e) {
      debugPrint('Error uploading user data to Firebase: $e');
    }
  }

  Future<void> deleteTask(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppRepo().uid)
          .collection("task")
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

  Future<void> updateTaskCompletion(String docId, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppRepo().uid)
          .collection("task")
          .doc(docId)
          .update({'isCompleted': isCompleted});
    } catch (e) {
      throw Exception("Error updating task completion: $e");
    }
  }
}
