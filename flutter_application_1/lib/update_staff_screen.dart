import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateStaffScreen extends StatefulWidget {
  final Map<String, String> staffMember;
  final String baseUrl;
  final VoidCallback onUpdate;

  const UpdateStaffScreen({
    super.key,
    required this.staffMember,
    required this.baseUrl,
    required this.onUpdate,
  });

  @override
  State<UpdateStaffScreen> createState() => _UpdateStaffScreenState();
}

class _UpdateStaffScreenState extends State<UpdateStaffScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController designationController;
  late TextEditingController departmentController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.staffMember['employee_id']);
    nameController = TextEditingController(text: widget.staffMember['name']);
    designationController = TextEditingController(text: widget.staffMember['designation']);
    departmentController = TextEditingController(text: widget.staffMember['department']);
  }

  Future<void> updateStaff() async {
    setState(() => isLoading = true);

    final id = widget.staffMember['id'];
    final url = Uri.parse('${widget.baseUrl}/profiles/$id/');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_id': idController.text,
        'name': nameController.text,
        'designation': designationController.text,
        'department': departmentController.text,
        'email': widget.staffMember['email'],
        'mobile': widget.staffMember['mobile'],
        'address': widget.staffMember['address'],
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      widget.onUpdate(); // Refresh staff list
      Navigator.pop(context); // Go back
    } else {
      print('Update failed: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: isLoading ? null : updateStaff,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update"),
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
