import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ GetX import
import 'login_page.dart';
import 'signup_page.dart';

class LandingPage extends StatelessWidget {
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Text(
              'Organize your tasks',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Simply and efficiently',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 50),
            // CREATE ACCOUNT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => SignupPage()); // ✅ GetX navigation
                },
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // LOG IN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => LoginPage()); // ✅ GetX navigation
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Spacer(flex: 3),
            Text(
              'Start managing your tasks today',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
