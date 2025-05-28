import 'package:flutter/material.dart';
import 'task_service.dart';
import 'app_drawer.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TaskService _taskService = TaskService();
  List<dynamic> _friends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final friends = await _taskService.fetchFriends();
      setState(() {
        _friends = friends;
      });
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    }
  }

  Future<void> _unfriendUser(String username) async {
    try {
      await _taskService.unfriendUser(username);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Unfriended @$username'),
      //     backgroundColor: Colors.tealAccent[400],
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );
      // Refresh the friends list after unfriending
      _fetchFriends();
    } catch (e) {
      debugPrint('Error unfriending user: $e');
    }
  }

  Widget _buildFriendCard(Map<String, dynamic> friend) {
    final firstName = friend['first_name'] ?? 'Unknown';
    final lastName = friend['last_name'] ?? 'User';
    final username = friend['username'] ?? '';
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
              onPressed: () => _unfriendUser(username),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[400],
                foregroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Unfriend',
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

  Widget _buildFriendList() {
    return _friends.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 60,
            color: Colors.blueGrey[700],
          ),
          SizedBox(height: 16),
          Text(
            'No friends found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ],
      ),
    )
        : RefreshIndicator(
      onRefresh: _fetchFriends,
      color: Colors.blue[400],
      backgroundColor: Colors.grey[900],
      child: ListView.builder(
        padding: EdgeInsets.only(top: 12, bottom: 80),
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          return _buildFriendCard(_friends[index]);
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
          'Friend List',
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
      body: _buildFriendList(),
    );
  }
}