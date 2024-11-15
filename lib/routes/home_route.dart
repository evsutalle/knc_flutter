import 'package:flutter/material.dart';
import 'package:knc/view/home_page.dart'; // Adjust this import based on your file structure

class HomeRoute extends StatelessWidget {
  final String userId;

  const HomeRoute({super.key, required this.userId}); // Expect userId as parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(userId: userId), // Pass userId to HomePage
    );
  }
}
