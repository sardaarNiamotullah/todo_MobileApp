import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/friend_request_controller.dart';
import 'app_drawer.dart';

class FriendRequestPage extends StatelessWidget {
  final controller = Get.put(FriendRequestController());

  Widget _buildFriendRequestCard(Map<String, dynamic> request) {
    final firstName = request['first_name'] ?? 'Unknown';
    final lastName = request['last_name'] ?? 'User';
    final username = request['username'] ?? '';
    final initials = (firstName.isNotEmpty ? firstName[0] : '') +
        (lastName.isNotEmpty ? lastName[0] : '');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Colors.blueGrey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue[400],
              child: Text(
                initials.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@$username',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.tealAccent[400]),
                  onPressed: () => controller.acceptFriendRequest(username),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.redAccent[400]),
                  onPressed: () => controller.rejectFriendRequest(username),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestList() {
    return Obx(() {
      if (controller.friendRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_outlined, size: 60, color: Colors.blueGrey[700]),
              SizedBox(height: 16),
              Text(
                'No friend requests found',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchFriendRequests,
        color: Colors.tealAccent[400],
        backgroundColor: Colors.grey[900],
        child: ListView.builder(
          padding: EdgeInsets.only(top: 12, bottom: 80),
          itemCount: controller.friendRequests.length,
          itemBuilder: (context, index) {
            return _buildFriendRequestCard(controller.friendRequests[index]);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Friend Requests',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.blue[400],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.menu, color: Colors.tealAccent[400], size: 28),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: Colors.tealAccent[400]))
            : _buildFriendRequestList();
      }),
    );
  }
}
