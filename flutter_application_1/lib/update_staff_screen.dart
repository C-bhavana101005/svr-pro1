import 'package:flutter/material.dart';

class UpdateStaffScreen extends StatelessWidget {
  final Map<String, String> staffMember;

  const UpdateStaffScreen({super.key, required this.staffMember});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController(text: staffMember['id']);
    final TextEditingController nameController = TextEditingController(text: staffMember['name']);
    final TextEditingController designationController = TextEditingController(text: staffMember['designation']);
    final TextEditingController departmentController = TextEditingController(text: staffMember['department']);

    return Scaffold(
      appBar: AppBar(title: const Text("Update Staff")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Employee ID", idController),
            _buildTextField("Name", nameController),
            _buildTextField("Designation", designationController),
            _buildTextField("Department", departmentController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // In pre-Django version, this just returns
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
