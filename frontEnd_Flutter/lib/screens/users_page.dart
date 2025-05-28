import 'package:flutter/material.dart';
import 'task_service.dart';
import 'app_drawer.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TaskService _taskService = TaskService();
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _taskService.fetchAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> _sendFriendRequest(String username) async {
    try {
      await _taskService.sendFriendRequest(username);
      // Refresh the user list to remove the user with the pending friend request
      await _fetchUsers();
    } catch (e) {
      debugPrint('Error sending friend request: $e');
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final firstName = user['first_name'] ?? 'Unknown';
    final lastName = user['last_name'] ?? 'User';
    final username = user['username'] ?? '';
    final initials = (firstName.isNotEmpty ? firstName[0] : '') + (lastName.isNotEmpty ? lastName[0] : '');

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
              onPressed: () => _sendFriendRequest(username),
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
    return _users.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 60,
            color: Colors.blueGrey[700],
          ),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ],
      ),
    )
        : RefreshIndicator(
      onRefresh: _fetchUsers,
      color: Colors.blue[400],
      backgroundColor: Colors.grey[900],
      child: ListView.builder(
        padding: EdgeInsets.only(top: 12, bottom: 80),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return _buildUserCard(_users[index]);
        },
      ),
    );
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
              decoration: BoxDecoration(
                // color: Colors.tealAccent[400],
                borderRadius: BorderRadius.circular(8),
              ),
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