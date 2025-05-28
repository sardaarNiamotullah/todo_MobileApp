// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'users_page.dart';
// import 'friends_page.dart';
// import 'friendrequest_page.dart';
// import 'landing_page.dart';
//
// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.grey[900], // Match TaskPage background
//       width: 200, // Narrower drawer for minimalism
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.grey[900], // Minimal: same as background
//             ),
//             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Tighter padding
//             child: Text(
//               'ToDoS',
//               style: TextStyle(
//                 color: Colors.tealAccent[400], // Match TaskPage accent
//                 fontSize: 24, // Slightly smaller than TaskPage title
//                 fontWeight: FontWeight.w600, // Lighter weight for simplicity
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text(
//               'Users',
//               style: TextStyle(
//                 color: Colors.grey[300], // Match TaskPage secondary text
//                 fontSize: 14, // Smaller for minimalism
//                 fontWeight: FontWeight.w400, // Lighter weight
//               ),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2), // Minimal padding
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => UsersPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text(
//               'Friends',
//               style: TextStyle(
//                 color: Colors.grey[300],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FriendsPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text(
//               'Requests',
//               style: TextStyle(
//                 color: Colors.grey[300],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FriendRequestPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text(
//               'Log Out',
//               style: TextStyle(
//                 color: Colors.redAccent[400], // Match TaskPage delete button
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//             onTap: () async {
//               final prefs = await SharedPreferences.getInstance();
//               // Clear the stored authentication token
//               await prefs.remove('authToken');
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => LandingPage()),
//                     (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'users_page.dart';
import 'friends_page.dart';
import 'friendrequest_page.dart';
import 'landing_page.dart';
import 'task_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900], // Match TaskPage background
      width: 200, // Narrower drawer for minimalism
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[900], // Minimal: same as background
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Tighter padding
            child: Text(
              'ToDoS',
              style: TextStyle(
                color: Colors.tealAccent[400], // Match TaskPage accent
                fontSize: 24, // Slightly smaller than TaskPage title
                fontWeight: FontWeight.w600, // Lighter weight for simplicity
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Users',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Friends',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendsPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Requests',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendRequestPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Log Out',
              style: TextStyle(
                color: Colors.redAccent[400], // Match TaskPage delete button
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              // Clear the stored authentication token
              await prefs.remove('authToken');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LandingPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}