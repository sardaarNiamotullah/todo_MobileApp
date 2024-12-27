const pool = require('../models/db');

exports.createTask = async (req, res) => {
  const { title, deadline, priority } = req.body;
  const { username } = req.user; // Added by authMiddleware

  try {
    const result = await pool.query(
      'INSERT INTO tasks (title, deadline, priority, created_by) VALUES ($1, $2, $3, $4) RETURNING *',
      [title, deadline, priority, username]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error creating task' });
  }
};

exports.updateTask = async (req, res) => {
  const { id } = req.params; // Task ID
  const { status, priority } = req.body; // Fields to update
  const { username } = req.user; // Authenticated user

  try {
    // Check if the task belongs to the user
    const task = await pool.query('SELECT * FROM tasks WHERE id = $1 AND created_by = $2', [id, username]);
    if (task.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found or not authorized' });
    }

    // Update the task
    const result = await pool.query(
      `UPDATE tasks SET 
        status = COALESCE($1, status), 
        priority = COALESCE($2, priority) 
      WHERE id = $3 
      RETURNING *`,
      [status, priority, id]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error updating task' });
  }
};


exports.deleteTask = async (req, res) => {
  const { id } = req.params; // Task ID
  const { username } = req.user; // Authenticated user

  try {
    // Check if the task belongs to the user
    const task = await pool.query('SELECT * FROM tasks WHERE id = $1 AND created_by = $2', [id, username]);
    if (task.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found or not authorized' });
    }

    // Delete the task
    await pool.query('DELETE FROM tasks WHERE id = $1', [id]);
    res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error deleting task' });
  }
};

exports.getAllTasks = async (req, res) => {
  const { username } = req.user; // Get the logged-in user's username from the auth middleware

  try {
    // Query to get all tasks created by the logged-in user
    const result = await pool.query('SELECT * FROM tasks WHERE created_by = $1', [username]);

    // If no tasks are found, send a 404 response
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this user' });
    }

    // Send the tasks as the response
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error fetching tasks' });
  }
};

