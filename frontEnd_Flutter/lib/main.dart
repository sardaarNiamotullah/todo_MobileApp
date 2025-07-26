// import 'package:flutter/material.dart';
// import 'screens/landing_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // 👈 Hides the DEBUG banner
//       title: 'ToDoS',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LandingPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ Import GetX
import 'screens/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // ✅ Replaced MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'ToDoS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(), // 👈 Starting page
    );
  }
}