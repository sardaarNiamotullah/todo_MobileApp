import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/task_page.dart';
import '../screens/login_page.dart';

class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> signup() async {
    isLoading.value = true;

    final username = usernameController.text;
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Auto-login after signup
        final loginResponse = await http.post(
          Uri.parse('http://localhost:3000/auth/login'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'username': username, 'password': password}),
        );

        if (loginResponse.statusCode == 200) {
          final loginData = jsonDecode(loginResponse.body);
          String token = loginData['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Get.off(() => TaskPage()); // Go to task page
        } else {
          Get.snackbar(
            'Signup Success',
            'Please log in',
            backgroundColor: Colors.green[400],
            colorText: Colors.black,
          );
          Get.off(() => LoginPage());
        }
      } else {
        Get.snackbar(
          'Signup Failed',
          response.body.toString(),
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during signup: $e');
      Get.snackbar(
        'Connection Error',
        'Please try again',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
