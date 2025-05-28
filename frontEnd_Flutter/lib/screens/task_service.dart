import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> fetchAllUsers() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/friends/allusers'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<List<dynamic>> fetchFriends() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/friends'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch friends');
    }
  }

  Future<void> sendFriendRequest(String user2Username) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/friends/sendFriendRequest'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'user2Username': user2Username}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send friend request: ${response.body}');
    }
  }

  Future<void> unfriendUser(String user2Username) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://localhost:3000/friends/$user2Username/unfriend'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unfriend user: ${response.body}');
    }
  }

  Future<List<dynamic>> fetchFriendRequests() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('http://localhost:3000/friends/incoming'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

  // Accept a friend request
  Future<Map<String, dynamic>> acceptFriendRequest(String username) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final url = Uri.parse('http://localhost:3000/friends/$username/accept');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Replace with the correct token
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to accept friend request');
    }
  }

// Reject a friend request
  Future<Map<String, dynamic>> rejectFriendRequest(String username) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final url = Uri.parse('http://localhost:3000/friends/$username/reject');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Replace with the correct token
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to reject friend request');
    }
  }


  Future<List<dynamic>> fetchOwnTasks() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/tasks/getown'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch own tasks');
    }
  }

  Future<List<dynamic>> fetchAssignedTasks() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/tasks/getassigned'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch assigned tasks');
    }
  }


  Future<List<dynamic>> fetchTasks() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/tasks/getall'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<void> createTask(String title, String deadline, String priority, String? assignedTo) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/tasks/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'deadline': deadline,
        'priority': priority,
        'assigned_to': assignedTo,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> editTask(int taskId, String title, String deadline, String priority) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('http://localhost:3000/tasks/update/$taskId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'deadline': deadline,
        'priority': priority,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    }
  }

  Future<void> completeTaskStatus(int taskId, String status) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('http://localhost:3000/tasks/update/$taskId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status');
    }
  }


  Future<void> deleteTask(int taskId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://localhost:3000/tasks/delete/$taskId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}