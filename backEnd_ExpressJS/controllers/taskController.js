const pool = require("../models/db");

exports.createTask = async (req, res) => {
  const { title, deadline, priority, assigned_to } = req.body;
  const { username } = req.user; // Authenticated user

  try {
    let assignedUsername = username; // Default to the creator's username

    if (assigned_to) {
      // Check if the assigned user exists
      const userCheck = await pool.query(
        "SELECT username FROM users WHERE username = $1",
        [assigned_to]
      );
      if (userCheck.rows.length === 0) {
        return res.status(400).json({ error: "Assigned user does not exist" });
      }
      assignedUsername = assigned_to;
    }

    // Insert the task into the database
    const result = await pool.query(
      "INSERT INTO tasks (title, deadline, priority, created_by, assigned_to) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [title, deadline, priority, username, assignedUsername]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error creating task" });
  }
};

exports.updateTask = async (req, res) => {
  const { id } = req.params; // Task ID
  const { title, status, priority, deadline, assigned_to } = req.body; // Fields to update
  const { username } = req.user; // Authenticated user

  try {
    // Check if the task belongs to the user
    const task = await pool.query(
      "SELECT * FROM tasks WHERE id = $1 AND assigned_to = $2",
      [id, username]
    );
    if (task.rows.length === 0) {
      return res
        .status(404)
        .json({ error: "Task not found or not authorized" });
    }

    let assignedUsername = task.rows[0].assigned_to; // Default to current assigned user

    if (assigned_to) {
      // Check if the assigned user exists
      const userCheck = await pool.query(
        "SELECT username FROM users WHERE username = $1",
        [assigned_to]
      );
      if (userCheck.rows.length === 0) {
        return res.status(400).json({ error: "Assigned user does not exist" });
      }
      assignedUsername = assigned_to;
    }

    // Update the task with all fields
    const result = await pool.query(
      `UPDATE tasks SET 
        title = COALESCE($1, title), 
        status = COALESCE($2, status), 
        priority = COALESCE($3, priority), 
        deadline = COALESCE($4, deadline),
        assigned_to = COALESCE($5, assigned_to)
      WHERE id = $6 
      RETURNING *`,
      [title, status, priority, deadline, assignedUsername, id]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error updating task" });
  }
};

exports.deleteTask = async (req, res) => {
  const { id } = req.params; // Task ID
  const { username } = req.user; // Authenticated user

  try {
    // Check if the task belongs to the user
    const task = await pool.query(
      "SELECT * FROM tasks WHERE id = $1 AND assigned_to = $2",
      [id, username]
    );
    if (task.rows.length === 0) {
      return res
        .status(404)
        .json({ error: "Task not found or not authorized" });
    }

    // Delete the task
    await pool.query("DELETE FROM tasks WHERE id = $1", [id]);
    res.json({ message: "Task deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error deleting task" });
  }
};

exports.getAllTasks = async (req, res) => {
  const { username } = req.user; // Authenticated user

  try {
    // Get tasks assigned to the user
    const result = await pool.query(
      "SELECT * FROM tasks WHERE assigned_to = $1",
      [username]
    );

    // If no tasks are found, send a 404 response
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "No tasks found for this user" });
    }

    // Send the tasks as the response
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error fetching tasks" });
  }
};
