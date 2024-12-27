const express = require('express');
const { createTask, getAllTasks, updateTask, deleteTask } = require('../controllers/taskController');
const { authenticateToken } = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/create', authenticateToken, createTask);
router.get('/getall', authenticateToken, getAllTasks);          // Get all tasks of a user
router.put('/update/:id', authenticateToken, updateTask);    // Update a task
router.delete('/delete/:id', authenticateToken, deleteTask); // Delete a task

module.exports = router;
