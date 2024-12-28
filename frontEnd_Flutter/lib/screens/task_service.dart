import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
