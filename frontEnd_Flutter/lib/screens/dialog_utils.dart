import 'package:flutter/material.dart';

Future<void> showCreateTaskDialog({
  required BuildContext context,
  required Function(String title, String deadline, String priority) onCreate,
}) async {
  final titleController = TextEditingController();
  final deadlineController = TextEditingController();
  String priority = 'Medium'; // Default value for the dropdown

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create New Task'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: deadlineController,
                  decoration: InputDecoration(labelText: 'Deadline'),
                ),
                DropdownButton<String>(
                  value: priority,
                  onChanged: (String? newValue) {
                    setState(() {
                      priority = newValue!;
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
            );
          },
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
              onCreate(
                titleController.text,
                deadlineController.text,
                priority,
              );
              Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
}

Future<void> showEditTaskDialog({
  required BuildContext context,
  required Map<String, dynamic> task,
  required Function(String, String, String) onEdit,
}) {
  final titleController = TextEditingController(text: task['title']);
  final deadlineController = TextEditingController(text: task['deadline']);
  final priorityController = TextEditingController(text: task['priority']);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(labelText: 'Deadline'),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(labelText: 'Priority'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onEdit(
                titleController.text,
                deadlineController.text,
                priorityController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

