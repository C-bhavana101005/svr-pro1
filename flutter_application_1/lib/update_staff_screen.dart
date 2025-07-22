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
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.staffMember['employee_id']);
    nameController = TextEditingController(text: widget.staffMember['name']);
    designationController = TextEditingController(text: widget.staffMember['designation']);
    departmentController = TextEditingController(text: widget.staffMember['department']);
    emailController = TextEditingController(text: widget.staffMember['email']);
    mobileController = TextEditingController(text: widget.staffMember['mobile']);
    addressController = TextEditingController(text: widget.staffMember['address']);
  }

  Future<void> updateStaff() async {
    setState(() => isLoading = true);

    final id = widget.staffMember['id'];
    final url = Uri.parse('${widget.baseUrl}/profiles/$id/');

    final Map<String, dynamic> updateData = {};

    if (idController.text != widget.staffMember['employee_id']) {
      updateData['employee_id'] = idController.text;
    }
    if (nameController.text != widget.staffMember['name']) {
      updateData['name'] = nameController.text;
    }
    if (designationController.text != widget.staffMember['designation']) {
      updateData['designation'] = designationController.text;
    }
    if (departmentController.text != widget.staffMember['department']) {
      updateData['department'] = departmentController.text;
    }
    if (emailController.text != widget.staffMember['email']) {
      updateData['email'] = emailController.text;
    }
    if (mobileController.text != widget.staffMember['mobile']) {
      updateData['mobile'] = mobileController.text;
    }
    if (addressController.text != widget.staffMember['address']) {
      updateData['address'] = addressController.text;
    }

    if (updateData.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes made.')),
      );
      return;
    }

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      widget.onUpdate();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${response.reasonPhrase}')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Staff Details"),
        backgroundColor: const Color(0xFF6A85B6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField("Employee ID", idController),
                        _buildTextField("Name", nameController),
                        _buildTextField("Designation", designationController),
                        _buildTextField("Department", departmentController),
                        _buildTextField("Email", emailController),
                        _buildTextField("Mobile", mobileController),
                        _buildTextField("Address", addressController, maxLines: 2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : updateStaff,
                    icon: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.update),
                    label: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color.fromARGB(255, 196, 213, 245),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
