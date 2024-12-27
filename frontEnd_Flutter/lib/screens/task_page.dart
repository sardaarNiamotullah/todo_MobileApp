// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
//
// class TaskPage extends StatefulWidget {
//   @override
//   _TaskPageState createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   List<dynamic> _tasks = [];
//   String? _token;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTokenAndFetchTasks();
//   }
//
//   Future<void> _loadTokenAndFetchTasks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//
//     if (_token != null) {
//       _fetchTasks();
//     } else {
//       print('No token found in storage.');
//     }
//   }
//
//   Future<void> _fetchTasks() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:3000/tasks/getall'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Bearer $_token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           _tasks = jsonDecode(response.body);
//         });
//       } else {
//         // Handle error, e.g., show a snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to fetch tasks'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error fetching tasks: $e');
//       // Handle error, e.g., show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching tasks'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _deleteTask(int taskId) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('http://localhost:3000/tasks/delete/$taskId'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Bearer $_token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         // Remove the deleted task from the list
//         setState(() {
//           _tasks.removeWhere((task) => task['id'] == taskId);
//         });
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task deleted successfully'),
//           ),
//         );
//       } else {
//         // Handle error, e.g., show a snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to delete task'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error deleting task: $e');
//       // Handle error, e.g., show a snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting task'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Tasks'),
//       ),
//       body: ListView.builder(
//         itemCount: _tasks.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_tasks[index]['title']),
//             subtitle: Text('Deadline: ${_tasks[index]['deadline']}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () {
//                     // Implement edit task functionality here
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     // Implement delete task functionality here
//                     _deleteTask(_tasks[index]['id']);
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:  () {
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

//////////////

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<dynamic> _tasks = [];
  String? _token;
  final deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchTasks();
  }

  Future<void> _loadTokenAndFetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      _fetchTasks();
    } else {
      print('No token found in storage.');
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/tasks/getall'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _tasks = jsonDecode(response.body);
        });
      } else {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch tasks'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching tasks'),
        ),
      );
    }
  }

  Future<void> _createTask(String title, String deadline, String priority) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/tasks/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'title': title,
          'deadline': deadline,
          'priority': priority,
        }),
      );

      if (response.statusCode == 201) {
        // Decode the response and add the new task to the list
        final newTask = jsonDecode(response.body);
        setState(() {
          _tasks.add(newTask);
        });
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task created successfully'),
          ),
        );
      } else {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create task'),
          ),
        );
      }
    } catch (e) {
      print('Error creating task: $e');
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating task'),
        ),
      );
    }
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/tasks/delete/$taskId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        // Remove the deleted task from the list
        setState(() {
          _tasks.removeWhere((task) => task['id'] == taskId);
        });
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task deleted successfully'),
          ),
        );
      } else {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete task'),
          ),
        );
      }
    } catch (e) {
      print('Error deleting task: $e');
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting task'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tasks[index]['title']),
            subtitle: Text('Deadline: ${_tasks[index]['deadline']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement edit task functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(_tasks[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateTaskDialog(BuildContext context) async {
    String _title = '';
    String _priority = 'Medium';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => _title = value,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
              ),
              DropdownButton<String>(
                value: _priority,
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createTask(_title, deadlineController.text, _priority);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}