import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget _buildDialogTextField({
  required TextEditingController controller,
  required String labelText,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[400]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey[800]!),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.tealAccent[400]!),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.blueGrey[900],
    ),
    style: TextStyle(color: Colors.white),
    readOnly: readOnly,
    onTap: onTap,
  );
}

Widget _buildPriorityDropdown({
  required String value,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    dropdownColor: Colors.blueGrey[900],
    decoration: InputDecoration(
      labelText: 'Priority',
      labelStyle: TextStyle(color: Colors.grey[400]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey[800]!),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.tealAccent[400]!),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.blueGrey[900],
    ),
    style: TextStyle(color: Colors.white),
    onChanged: onChanged,
    items: <String>['Low', 'Medium', 'High']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.tealAccent[400]!,
            onPrimary: Colors.grey[900]!,
            surface: Colors.grey[900]!,
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: Colors.grey[900],
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.tealAccent[400]!,
              onPrimary: Colors.grey[900]!,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final DateTime dateTime = DateTime(
          picked.year, picked.month, picked.day,
          time.hour, time.minute
      );
      controller.text = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
    }
  }
}

Widget _buildFriendDropdown({
  required Future<List<dynamic>> friendsFuture,
  required String? selectedFriend,
  required ValueChanged<String?> onChanged,
}) {
  return FutureBuilder<List<dynamic>>(
    future: friendsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(color: Colors.tealAccent[400]));
      } else if (snapshot.hasError) {
        return Text(
          'Error loading friends',
          style: TextStyle(color: Colors.red[400]),
        );
      } else {
        final friends = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: selectedFriend,
          dropdownColor: Colors.blueGrey[900],
          decoration: InputDecoration(
            labelText: 'Assign to (optional)',
            labelStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[800]!),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent[400]!),
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.blueGrey[900],
          ),
          style: TextStyle(color: Colors.white),
          onChanged: onChanged,
          items: friends.map<DropdownMenuItem<String>>((friend) {
            return DropdownMenuItem<String>(
              value: friend['username'],
              child: Text(
                friend['name'] ?? friend['username'],
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        );
      }
    },
  );
}

Widget _buildDialogButton({
  required String text,
  required VoidCallback onPressed,
  Color? backgroundColor,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.blueGrey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Future<void> showCreateTaskDialog({
  required BuildContext context,
  required Function(String title, String deadline, String priority, String? assignedTo) onCreate,
  required Future<List<dynamic>> Function() fetchFriends,
}) async {
  final titleController = TextEditingController();
  final deadlineController = TextEditingController();
  String priority = 'Medium';
  String? selectedFriend;

  // Get friends list before showing dialog
  final friendsFuture = fetchFriends();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Create New Task',
          style: TextStyle(
            color: Colors.tealAccent[400],
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogTextField(
                    controller: titleController,
                    labelText: 'Title',
                  ),
                  SizedBox(height: 16),
                  _buildDialogTextField(
                    controller: deadlineController,
                    labelText: 'Deadline',
                    readOnly: true,
                    onTap: () => _selectDate(context, deadlineController),
                  ),
                  SizedBox(height: 16),
                  _buildPriorityDropdown(
                    value: priority,
                    onChanged: (newValue) => setState(() => priority = newValue!),
                  ),
                  SizedBox(height: 16),
                  _buildFriendDropdown(
                    friendsFuture: friendsFuture,
                    selectedFriend: selectedFriend,
                    onChanged: (newValue) => setState(() => selectedFriend = newValue),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          _buildDialogButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          _buildDialogButton(
            text: 'Create',
            onPressed: () {
              if (titleController.text.isEmpty || deadlineController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Title and Deadline are required'),
                    backgroundColor: Colors.red[400],
                  ),
                );
                return;
              }
              onCreate(
                titleController.text,
                deadlineController.text,
                priority,
                selectedFriend,
              );
              Navigator.of(context).pop();
            },
            backgroundColor: Colors.tealAccent[400],
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
  String priority = task['priority'];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit Task',
          style: TextStyle(
            color: Colors.tealAccent[400],
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogTextField(
                    controller: titleController,
                    labelText: 'Title',
                  ),
                  SizedBox(height: 16),
                  _buildDialogTextField(
                    controller: deadlineController,
                    labelText: 'Deadline',
                    readOnly: true,
                    onTap: () => _selectDate(context, deadlineController),
                  ),
                  SizedBox(height: 16),
                  _buildPriorityDropdown(
                    value: priority,
                    onChanged: (newValue) => setState(() => priority = newValue!),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          _buildDialogButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          _buildDialogButton(
            text: 'Save',
            onPressed: () {
              if (titleController.text.isEmpty || deadlineController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Title and Deadline are required'),
                    backgroundColor: Colors.red[400],
                  ),
                );
                return;
              }
              onEdit(
                titleController.text,
                deadlineController.text,
                priority,
              );
              Navigator.of(context).pop();
            },
            backgroundColor: Colors.tealAccent[400],
          ),
        ],
      );
    },
  );
}