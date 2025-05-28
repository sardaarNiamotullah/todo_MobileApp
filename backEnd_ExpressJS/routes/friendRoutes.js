const express = require('express');
const { getAllUsers, getFriends, sendFriendRequest, acceptFriendRequest, rejectFriendRequest, unfriend, incomingFriendRequests } = require('../controllers/friendController');
const { authenticateToken } = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/allusers', authenticateToken, getAllUsers)

router.get('/', authenticateToken, getFriends);       // Get friend list
router.get('/incoming', authenticateToken, incomingFriendRequests); // Get incoming friend requests
router.post('/sendFriendRequest', authenticateToken, sendFriendRequest)
router.put('/:user2Username/accept', authenticateToken, acceptFriendRequest); // Accept friend request
router.delete('/:user2Username/reject', authenticateToken, rejectFriendRequest); // Reject friend request
router.delete('/:user2Username/unfriend', authenticateToken, unfriend); // Unfriend a user


module.exports = router;