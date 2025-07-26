import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/task_page.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;

    final username = usernameController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.to(() => TaskPage()); // ✅ Navigate using GetX
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid credentials',
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar(
        'Error',
        'Connection error: Please try again',
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
    passwordController.dispose();
    super.onClose();
  }
}
