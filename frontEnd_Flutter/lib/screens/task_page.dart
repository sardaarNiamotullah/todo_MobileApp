import 'package:flutter/material.dart';
import 'task_service.dart';
import 'dialog_utils.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = TaskService();
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await _taskService.fetchTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $e')),
      );
    }
  }

  Future<void> _createTask(String title, String deadline, String priority) async {
    try {
      await _taskService.createTask(title, deadline, priority);
      _fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating task: $e')),
      );
    }
  }

  Future<void> _editTask(int taskId, String title, String deadline, String priority) async {
    try {
      await _taskService.editTask(taskId, title, deadline, priority);
      _fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task edited successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error editing task: $e')),
      );
    }
  }


  Future<void> _deleteTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  Future<void> _completeTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task completed.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  // String _formatDate(String dateTime) {
  //   final date = DateTime.parse(dateTime);
  //   return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  // }
  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime).toLocal();
    final hours = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minutes = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${hours}:${minutes} $period';
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
            leading: IconButton(
              icon: Icon(Icons.circle_outlined),
              onPressed: () {
                _completeTask(_tasks[index]['id']);
              },
            ),
            title: Text(_tasks[index]['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Due: ${_formatDate(_tasks[index]['deadline'])}'),
                Text('Priority: ${_tasks[index]['priority']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showEditTaskDialog(
                      context: context,
                      task: _tasks[index],
                      onEdit: (String title, String deadline, String priority) async {
                        _editTask(_tasks[index]['id'], title, deadline, priority);
                      },
                    );
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
          showCreateTaskDialog(
            context: context,
            onCreate: _createTask,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

