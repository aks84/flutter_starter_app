import 'package:flutter/material.dart';

// Individual Screen Implementations
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Screen', 
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
      ),
    );
  }
}
