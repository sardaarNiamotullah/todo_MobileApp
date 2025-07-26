import 'package:flutter/material.dart';
import 'task_service.dart';
import 'dialog_utils.dart';
import 'app_drawer.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with SingleTickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  List<dynamic> _allTasks = [];
  List<dynamic> _ownTasks = [];
  List<dynamic> _assignedTasks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAllTasks();
    _fetchOwnTasks();
    _fetchAssignedTasks();
  }

  Future<void> _fetchAllTasks() async {
    try {
      final tasks = await _taskService.fetchTasks();
      setState(() {
        _allTasks = tasks;
      });
    } catch (e) {
      debugPrint('Error fetching all tasks: $e');
    }
  }

  Future<void> _fetchOwnTasks() async {
    try {
      final tasks = await _taskService.fetchOwnTasks();
      setState(() {
        _ownTasks = tasks;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _fetchAssignedTasks() async {
    try {
      final tasks = await _taskService.fetchAssignedTasks();
      setState(() {
        _assignedTasks = tasks;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _createTask(String title, String deadline, String priority, String? assignedTo) async {
    try {
      await _taskService.createTask(title, deadline, priority, assignedTo);
      _fetchAllTasks();
      _fetchOwnTasks();
      _fetchAssignedTasks();
    } catch (e) {
      debugPrint('Error creating task: $e');
    }
  }

  Future<void> _editTask(int taskId, String title, String deadline, String priority) async {
    try {
      await _taskService.editTask(taskId, title, deadline, priority);
      _fetchAllTasks();
      _fetchOwnTasks();
      _fetchAssignedTasks();
    } catch (e) {
      debugPrint('Error editing task: $e');
    }
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _fetchAllTasks();
      _fetchOwnTasks();
      _fetchAssignedTasks();
    } catch (e) {
      debugPrint('Error deleting tasks: $e');
    }
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime).toLocal();
    final hours = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minutes = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${hours}:${minutes} $period';
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
        return Colors.greenAccent;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Colors.blueGrey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue[400], size: 18),
                      onPressed: () {
                        showEditTaskDialog(
                          context: context,
                          task: task,
                          onEdit: (String title, String deadline, String priority) async {
                            _editTask(task['id'], title, deadline, priority);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent[400], size: 18),
                      onPressed: () {
                        _deleteTask(task['id']);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority: ${task['priority']}',
                  style: TextStyle(
                    color: _getPriorityColor(task['priority']),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: task['status'] == 'Completed'
                        ? Colors.tealAccent[400]
                        : Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['status'],
                    style: TextStyle(
                      color: task['status'] == 'Completed'
                          ? Colors.grey[900]
                          : Colors.grey[300],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey[400],
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Due: ${_formatDate(task['deadline'])}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
                Checkbox(
                  value: task['status'] == 'Completed',
                  activeColor: Colors.tealAccent[400],
                  checkColor: Colors.grey[900],
                  onChanged: (bool? value) async {
                    try {
                      await _taskService.completeTaskStatus(
                          task['id'],
                          value == true ? 'Completed' : 'Pending'
                      );
                      _fetchAllTasks();
                      _fetchOwnTasks();
                      _fetchAssignedTasks();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       value == true
                      //           ? 'Task marked as completed'
                      //           : 'Task marked as pending',
                      //     ),
                      //     backgroundColor: Colors.tealAccent[400],
                      //     behavior: SnackBarBehavior.floating,
                      //   ),
                      // );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating task status: $e'),
                          backgroundColor: Colors.red[400],
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<dynamic> tasks) {
    return tasks.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 60,
            color: Colors.blueGrey[700],
          ),
          SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ],
      ),
    )
        : RefreshIndicator(
      onRefresh: () async {
        await _fetchAllTasks();
        await _fetchOwnTasks();
        await _fetchAssignedTasks();
      },
      color: Colors.tealAccent[400],
      backgroundColor: Colors.grey[900],
      child: ListView.builder(
        padding: EdgeInsets.only(top: 12, bottom: 80),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskCard(tasks[index]);
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
          'ToDoS',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent[400],
          labelColor: Colors.tealAccent[400],
          unselectedLabelColor: Colors.grey[500],
          tabs: [
            Tab(text: 'All Tasks'),
            Tab(text: 'Own Tasks'),
            Tab(text: 'Assigned Tasks'),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(_allTasks),
          _buildTaskList(_ownTasks),
          _buildTaskList(_assignedTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskDialog(
            context: context,
            onCreate: _createTask,
            fetchFriends: _taskService.fetchFriends,
          );
        },
        backgroundColor: Colors.tealAccent[400],
        child: Icon(
          Icons.add,
          color: Colors.grey[900],
          size: 28,
        ),
        elevation: 4,
      ),
    );
  }
}


