import 'package:flutter/material.dart';

class SuperAdmin2 extends StatelessWidget {
  const SuperAdmin2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bar_chart, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text("Report Overview (Static)", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
