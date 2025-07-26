import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController()); // Inject controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(
            color: Colors.blue[400],
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue[400]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: controller.usernameController,
                style: TextStyle(color: Colors.white),
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[800]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[800]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900],
                ),
              ),
              SizedBox(height: 40),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
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
              )),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
