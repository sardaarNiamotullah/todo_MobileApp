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