import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/task_service.dart';

class FriendRequestController extends GetxController {
  final TaskService _taskService = TaskService();
  var isLoading = true.obs;
  var friendRequests = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriendRequests();
  }

  Future<void> fetchFriendRequests() async {
    try {
      isLoading(true);
      final requests = await _taskService.fetchFriendRequests();
      friendRequests.assignAll(requests);
    } catch (e) {
      debugPrint('Error fetching friend requests: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptFriendRequest(String username) async {
    try {
      final response = await _taskService.acceptFriendRequest(username);
      if (response['message'] == 'Friend request accepted') {
        friendRequests.removeWhere((r) => r['username'] == username);
      }
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
    }
  }

  Future<void> rejectFriendRequest(String username) async {
    try {
      final response = await _taskService.rejectFriendRequest(username);
      if (response['message'] == 'Friend request rejected') {
        friendRequests.removeWhere((r) => r['username'] == username);
      }
    } catch (e) {
      debugPrint('Error rejecting friend request: $e');
    }
  }
}
