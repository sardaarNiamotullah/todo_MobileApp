# ToDoS — Collaborative Task Management App 📋

Welcome to **ToDoS**, a full-stack ToDo management platform built with ❤️ using **Flutter**, **Express.js**, **PostgreSQL**, and **JWT authentication**! This app empowers users to **manage personal tasks, collaborate with friends, and assign tasks for group productivity**.

> Your go-to app for organizing tasks, connecting with friends, and working together seamlessly.

## ✨ Features

- **📝 Task Management:** Create, edit, delete, and mark tasks as complete with deadlines and priorities.
- **👥 Friend System:** Discover users, send/receive friend requests, and build your network.
- **🤝 Collaborative Tasks:** Assign tasks to friends for group collaboration.
- **🔒 Secure Authentication:** JWT-based login for secure user access.
- **🎨 Modern UI:** Sleek, minimalist design with Flutter and Material Design.
- **📱 Responsive Design:** Seamless experience on mobile devices (iOS and Android).
- **💾 Persistent Storage:** Reliable data storage with PostgreSQL.

## 📋 ToDoS Capabilities

- ToDoS is designed to streamline personal and group task management. Users can: Manage Personal Tasks: Add, edit, delete, or complete tasks with customizable priorities (High, Medium, Low) and deadlines.

- Connect with Others: View all users, send friend requests, accept/reject incoming requests, and unfriend users.

- Collaborate Efficiently: Assign tasks to friends, enabling group workflows and shared responsibility.

- Stay Organized: View tasks in three categories: All Tasks, Own Tasks, and Assigned Tasks, with a clean, tabbed interface.

## 🔐 Authentication

- **JWT Authentication:** Secure login with username and password, protected by bcrypt hashing and jsonwebtoken.
- **🔒 Session Management:** Store JWT tokens using shared_preferences for persistent user sessions.

## 📸 UI Highlights

- **📋 Task Dashboard:** Tabbed interface for All Tasks, Own Tasks, and Assigned Tasks with a dark theme and teal accents.
- **👤 User Profiles:** Display first/last names and usernames with circular avatars showing initials.
- **🤝 Friend Management:** Intuitive interfaces for sending, accepting, rejecting, and managing friend requests.
- **🔍 Minimalist Design:** Clean, rounded cards and a consistent color scheme (grey, teal, blue).
- **⋮ Navigation Drawer:** Easy access to Home (Tasks), Users, Friends, Requests, and Logout.

## 🏗️ Tech Stack

### 🖼️ Frontend

- **Flutter:** Cross-platform framework for building iOS and Android apps.
- **provider:** State management for reactive UI updates.
- **shared_preferences:** Persistent storage for JWT tokens.
- **intl:** Date and time formatting for task deadlines.
- **cupertino_icons:** Icon set for iOS-style UI elements.
- **Material Design:** Google’s design system for a modern, consistent UI.

### 🔧 Backend

- **Express.js:** Fast, minimalist web framework for Node.js.
- **PostgreSQL:** Robust open-source relational database.
- **bcrypt:** Secure password hashing for user authentication.
- **jsonwebtoken:** JWT-based authentication for secure API access.

## 🚀 Getting Started

### Prerequisites

- Flutter (v3.0 or later)
- Dart (v2.17 or later)
- Node.js (v18 or later)
- PostgreSQL (v13 or later)
- npm or yarn

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/sardaarNiamotullah/todo_MobileApp.git
   cd todo_MobileApp
   ```

2. **Backend Setup**

   ```bash
   cd backEnd_ExpressJS
   npm install

   # Configure environment variables
   cp .env.example .env
   # Edit .env with your PostgreSQL connection string and JWT secret

   # Set up the database
   psql -U your_username -d your_database -f schema.sql

   # Start the development server
   npm run dev
   ```

3. **Frontend Setup**

   ```bash
   cd ../frontEnd_Flutter
   flutter pub get

   # Configure API
   # Update lib/config.dart with your backend API URL (e.g., http://localhost:3000)

   # Run the app
   flutter run
   ```

4. **Open the App**
   - On your emulator or physical device, the app will launch.
   - Alternatively, use `flutter run -d chrome` for web testing.

## 🔧 Environment Variables

### Backend (.env)

```
DATABASE_URL="postgresql://user:password@localhost:5432/todos"
JWT_SECRET="your-jwt-secret"
PORT=3000
```

## 📚 API Documentation

### Authentication Endpoints

- `GET /auth/login` - Log in with username and password, returns JWT token.
- `GET /auth/register` - Create a new user account.

### Task Endpoints

- `GET /api/chat` - Send a user message to the chatbot.

## 📂 Project Structure

```

ai_chatbot/
├── backEnd_ExpressJS/
└── frontEnd_Flutter/

```

## Database Schema

```bash
# Users Table

CREATE TABLE users (
username VARCHAR(50) PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
password VARCHAR(255) NOT NULL
);

# Friends Table

CREATE TABLE friends (
  user1_username VARCHAR(50) REFERENCES users(username),
  user2_username VARCHAR(50) REFERENCES users(username),
  status VARCHAR(20) CHECK (status IN ('Pending', 'Accepted')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user1_username, user2_username)
);

# Task Table

CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  deadline TIMESTAMP,
  priority VARCHAR(20) CHECK (priority IN ('High', 'Medium', 'Low')),
  status VARCHAR(20) CHECK (status IN ('Pending', 'Completed')),
  created_by VARCHAR(50) REFERENCES users(username),
  assigned_to VARCHAR(50) REFERENCES users(username),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🤝 Contributing

Got an idea to make it even better? Fork it, code it, and create a PR — contributions are **always welcome**!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🖋️ Author

**Sardaar Niamotullah**

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Express.js](https://expressjs.com/)
- [PostgreSQL](https://www.postgresql.org/)
