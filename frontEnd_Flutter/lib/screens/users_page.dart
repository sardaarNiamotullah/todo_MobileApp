import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';
import 'app_drawer.dart';

class UsersPage extends StatelessWidget {
  final UsersController controller = Get.put(UsersController());

  Widget _buildUserCard(Map<String, dynamic> user) {
    final firstName = user['first_name'] ?? 'Unknown';
    final lastName = user['last_name'] ?? 'User';
    final username = user['username'] ?? '';
    final initials = (firstName.isNotEmpty ? firstName[0] : '') +
        (lastName.isNotEmpty ? lastName[0] : '');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Colors.blueGrey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
            ElevatedButton(
              onPressed: () => controller.sendFriendRequest(username),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[400],
                foregroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Obx(() {
      final users = controller.users;

      if (users.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 60, color: Colors.blueGrey[700]),
              SizedBox(height: 16),
              Text(
                'No users found',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchUsers,
        color: Colors.blue[400],
        backgroundColor: Colors.grey[900],
        child: ListView.builder(
          padding: EdgeInsets.only(top: 12, bottom: 80),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildUserCard(users[index]);
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
          'All Users',
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
              child: Icon(
                Icons.menu,
                color: Colors.tealAccent[400],
                size: 28,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: _buildUserList(),
    );
  }
}
