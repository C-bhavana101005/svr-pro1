import 'package:flutter/material.dart';

class SuperAdminAccount extends StatelessWidget {
  const SuperAdminAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Admin Profile")),
      body: const Center(
        child: Text(
          "Welcome, Super Admin!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
