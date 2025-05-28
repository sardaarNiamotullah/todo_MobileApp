import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() => _isLoading = true);
    final username = _usernameController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // If your signup API doesn't return a token, we can either:
        // 1. Automatically log the user in after signup, or
        // 2. Redirect to login page

        // Option 1: Auto-login after signup
        final loginResponse = await http.post(
          Uri.parse('http://localhost:3000/auth/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }),
        );

        if (loginResponse.statusCode == 200) {
          final Map<String, dynamic> loginData = jsonDecode(loginResponse.body);
          String token = loginData['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TaskPage()),
          );
        } else {
          // If auto-login fails, redirect to login page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created! Please log in'),
              backgroundColor: Colors.green[400],
            ),
          );
          Navigator.pop(context); // Go back to login page
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed: ${response.body}'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: Please try again'),
          backgroundColor: Colors.red[400],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              _buildTextField(_usernameController, 'Username'),
              SizedBox(height: 20),
              _buildTextField(_firstNameController, 'First Name'),
              SizedBox(height: 20),
              _buildTextField(_lastNameController, 'Last Name'),
              SizedBox(height: 20),
              _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 20),
              _buildTextField(_passwordController, 'Password', isPassword: true),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  child: _isLoading
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
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigator.pop(context); // Go back to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(
                    color: Colors.tealAccent[400],
                  ),
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