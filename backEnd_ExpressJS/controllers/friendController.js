const pool = require("../models/db");
const jwt = require('jsonwebtoken');

// Get all users, excluding friends and pending friend requests
exports.getAllUsers = async (req, res) => {
  try {
    // Extract token from Authorization header
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    // Decode token to get current user's username
    const decoded = jwt.verify(token, process.env.JWT_SECRET); // Replace with your JWT secret
    const currentUser = decoded.username; // Assuming the token payload includes username

    // Query to fetch all users except friends and pending friend requests
    const query = `
      SELECT username, first_name, last_name
      FROM users
      WHERE username != $1
      AND username NOT IN (
        -- Exclude accepted friends (where current user is user1 or user2)
        SELECT user1_username
        FROM friends
        WHERE user2_username = $1 AND status = 'Accepted'
        UNION
        SELECT user2_username
        FROM friends
        WHERE user1_username = $1 AND status = 'Accepted'
        -- Exclude users who sent a friend request to current user
        UNION
        SELECT user1_username
        FROM friends
        WHERE user2_username = $1 AND status = 'Pending'
        -- Exclude users to whom current user sent a friend request
        UNION
        SELECT user2_username
        FROM friends
        WHERE user1_username = $1 AND status = 'Pending'
      )
    `;
    const result = await pool.query(query, [currentUser]);

    res.json(result.rows); // Respond with the filtered list of users
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error fetching users' });
  }
};

exports.getFriends = async (req, res) => {
  const { username } = req.user; // Authenticated user

  try {
    const result = await pool.query(
      `SELECT 
         u.username,
         u.first_name,
         u.last_name,
         u.email
       FROM users u
       JOIN (
         SELECT 
           CASE 
             WHEN user1_username = $1 THEN user2_username 
             ELSE user1_username 
           END AS friend_username
         FROM friends 
         WHERE (user1_username = $1 OR user2_username = $1) AND status = 'Accepted'
       ) f ON u.username = f.friend_username`,
      [username]
    );

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error fetching friends" });
  }
};

exports.sendFriendRequest = async (req, res) => {
  const { username } = req.user;  // Authenticated user
  const { user2Username } = req.body;  // The other user to send the friend request to

  if (username === user2Username) {
    return res.status(400).json({ error: "You cannot send a friend request to yourself." });
  }

  try {
    // Check if the friend request already exists (either pending or accepted)
    const existingRequest = await pool.query(
      `SELECT * FROM friends WHERE (user1_username = $1 AND user2_username = $2) OR (user1_username = $2 AND user2_username = $1)`,
      [username, user2Username]
    );

    if (existingRequest.rows.length > 0) {
      return res.status(400).json({ error: "Friend request already exists." });
    }

    // Insert new friend request with 'Pending' status
    await pool.query(
      `INSERT INTO friends (user1_username, user2_username, status) VALUES ($1, $2, 'Pending')`,
      [username, user2Username]
    );

    res.status(201).json({ message: "Friend request sent" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error sending friend request" });
  }
};

exports.acceptFriendRequest = async (req, res) => {
  const { username } = req.user; // Authenticated user
  const { user2Username } = req.params; // The user who sent the friend request

  if (username === user2Username) {
    return res.status(400).json({ error: "You cannot accept a request from yourself." });
  }

  try {
    // Check if a pending friend request exists
    const request = await pool.query(
      `SELECT * FROM friends WHERE user1_username = $1 AND user2_username = $2 AND status = 'Pending'`,
      [user2Username, username]
    );

    if (request.rows.length === 0) {
      return res.status(400).json({ error: "No pending friend request found." });
    }

    // Update the request status to 'Accepted'
    await pool.query(
      `UPDATE friends SET status = 'Accepted' WHERE user1_username = $1 AND user2_username = $2`,
      [user2Username, username]
    );

    res.json({ message: "Friend request accepted" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error accepting friend request" });
  }
};

exports.rejectFriendRequest = async (req, res) => {
  const { username } = req.user; // Authenticated user
  const { user2Username } = req.params; // The user who sent the friend request

  if (username === user2Username) {
    return res.status(400).json({ error: "You cannot reject a request from yourself." });
  }

  try {
    // Check if a pending friend request exists
    const request = await pool.query(
      `SELECT * FROM friends WHERE user1_username = $1 AND user2_username = $2 AND status = 'Pending'`,
      [user2Username, username]
    );

    if (request.rows.length === 0) {
      return res.status(400).json({ error: "No pending friend request found." });
    }

    // Delete the pending friend request
    await pool.query(
      `DELETE FROM friends WHERE user1_username = $1 AND user2_username = $2`,
      [user2Username, username]
    );

    res.json({ message: "Friend request rejected" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error rejecting friend request" });
  }
};

exports.unfriend = async (req, res) => {
  const { username } = req.user; // Authenticated user
  const { user2Username } = req.params; // The user to unfriend

  try {
    // Check if the users are already friends
    const friendship = await pool.query(
      `SELECT * FROM friends WHERE (user1_username = $1 AND user2_username = $2 OR user1_username = $2 AND user2_username = $1) AND status = 'Accepted'`,
      [username, user2Username]
    );

    if (friendship.rows.length === 0) {
      return res.status(400).json({ error: "You are not friends with this user." });
    }

    // Delete the friendship record
    await pool.query(
      `DELETE FROM friends WHERE (user1_username = $1 AND user2_username = $2 OR user1_username = $2 AND user2_username = $1)`,
      [username, user2Username]
    );

    res.json({ message: "Friendship deleted" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error unfriending user" });
  }
};

exports.incomingFriendRequests = async (req, res) => {
  const { username } = req.user; // Authenticated user

  try {
    // Query to get details of users who sent friend requests to the authenticated user
    const result = await pool.query(
      `SELECT 
         u.username,
         u.first_name,
         u.last_name,
         u.email
       FROM users u
       JOIN friends f
         ON u.username = f.user1_username
       WHERE f.user2_username = $1 AND f.status = 'Pending'`,
      [username]
    );

    res.json(result.rows); // Send the list of incoming friend requests
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error fetching incoming friend requests" });
  }
};
