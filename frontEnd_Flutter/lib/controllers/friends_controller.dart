import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/task_service.dart';

class FriendsController extends GetxController {
  final TaskService _taskService = TaskService();
  var friends = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    try {
      isLoading(true);
      final result = await _taskService.fetchFriends();
      friends.assignAll(result);
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> unfriendUser(String username) async {
    try {
      await _taskService.unfriendUser(username);
      friends.removeWhere((f) => f['username'] == username);
    } catch (e) {
      debugPrint('Error unfriending user: $e');
    }
  }
}
