import 'package:flutter/material.dart';
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
            // Moved the content higher by reducing the top padding
            Spacer(flex: 2), // Adjusts the top spacing
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
            // Create Account button first
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
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
            // Brighter Login button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Changed to white for better contrast
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400], // Brighter blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Spacer(flex: 3), // Adjusts the bottom spacing
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