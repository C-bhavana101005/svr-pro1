import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? gender;
  Uint8List? selectedImage;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedImage = result.files.single.bytes!;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  void handleSubmit() {
    // This is just a placeholder. In pre-Django version, this does nothing.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Submitted (local only, no backend)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Staff")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Employee ID", employeeIdController),
            _buildTextField("Name", nameController),
            _buildGenderSelector(),
            _buildTextField("Designation", designationController),
            _buildTextField("Department", departmentController),
            _buildTextField("Email", emailController),
            _buildTextField("Mobile", mobileController),
            _buildTextField("Address", addressController),
            const SizedBox(height: 16),
            _buildImageSection(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSubmit,
              child: const Text("Add"),
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

  Widget _buildGenderSelector() {
    return Row(
      children: [
        const Text("Gender: "),
        Radio<String>(
          value: 'Male',
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value),
        ),
        const Text("Male"),
        Radio<String>(
          value: 'Female',
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value),
        ),
        const Text("Female"),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        if (selectedImage != null)
          Stack(
            children: [
              Image.memory(selectedImage!, height: 150),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: removeImage,
                ),
              ),
            ],
          )
        else
          ElevatedButton(
            onPressed: pickImage,
            child: const Text("Select Image"),
          ),
      ],
    );
  }
}
