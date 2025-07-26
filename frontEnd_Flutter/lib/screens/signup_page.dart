import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupPage extends StatelessWidget {
  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.tealAccent[400],
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.tealAccent[400]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Create your account',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(controller.usernameController, 'Username'),
              SizedBox(height: 20),
              _buildTextField(controller.firstNameController, 'First Name'),
              SizedBox(height: 20),
              _buildTextField(controller.lastNameController, 'Last Name'),
              SizedBox(height: 20),
              _buildTextField(controller.emailController, 'Email', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 20),
              _buildTextField(controller.passwordController, 'Password', isPassword: true),
              SizedBox(height: 40),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.signup,
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
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
              )),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.offNamed('/login'); // or Get.off(() => LoginPage());
                },
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: Colors.tealAccent[400]),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText, {
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey[800]!),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.blueGrey[900],
      ),
    );
  }
}
