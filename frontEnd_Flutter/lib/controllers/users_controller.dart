import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/task_service.dart';

class UsersController extends GetxController {
  final TaskService _taskService = TaskService();
  var users = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final result = await _taskService.fetchAllUsers();
      users.value = result;
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> sendFriendRequest(String username) async {
    try {
      await _taskService.sendFriendRequest(username);
      await fetchUsers(); // Refresh after sending request
    } catch (e) {
      debugPrint('Error sending friend request: $e');
    }
  }
}
