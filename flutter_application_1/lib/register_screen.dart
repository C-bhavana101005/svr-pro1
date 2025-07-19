import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? gender;
  Uint8List? selectedImage;
  String? fileName;

  String? selectedDesignation;
  String? selectedDepartment;

  final List<String> designationOptions = [
    'Principal',
    'HOD',
    'Dean',
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Non-Teaching Staff',
  ];

  final List<String> defaultDepartmentOptions = [
    'CSE',
    'ECE',
    'EEE',
    'MECH',
    'CIVIL',
    'IT',
    'H&S',
  ];

  List<String> departmentOptions = [];

  bool isMobileValid = true;
  late FocusNode mobileFocusNode;

  @override
  void initState() {
    super.initState();
    departmentOptions = List.from(defaultDepartmentOptions);

    mobileFocusNode = FocusNode();
    mobileFocusNode.addListener(() {
      if (!mobileFocusNode.hasFocus) {
        final mobile = mobileController.text.trim();
        bool valid = mobile.length == 10 && RegExp(r'^[0-9]+$').hasMatch(mobile);
        setState(() {
          isMobileValid = valid;
        });
      }
    });
  }

  @override
  void dispose() {
    mobileFocusNode.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedImage = result.files.single.bytes!;
        fileName = result.files.single.name;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
      fileName = null;
    });
  }

  Future<void> handleSubmit() async {
    final mobile = mobileController.text.trim();
    if (mobile.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      setState(() {
        isMobileValid = false;
      });
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    final uri = Uri.parse("http://127.0.0.1:8000/api/profiles/");

    var request = http.MultipartRequest("POST", uri)
      ..fields['employee_id'] = employeeIdController.text
      ..fields['name'] = nameController.text
      ..fields['gender'] = gender ?? ''
      ..fields['designation'] = selectedDesignation ?? ''
      ..fields['department'] = selectedDepartment ?? ''
      ..fields['email'] = emailController.text
      ..fields['mobile'] = mobile
      ..fields['address'] = addressController.text
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        selectedImage!,
        filename: fileName ?? 'photo.jpg',
      ));

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully registered!")),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to register: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _resetForm() {
    employeeIdController.clear();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    gender = null;
    selectedDesignation = null;
    selectedDepartment = null;
    selectedImage = null;
    fileName = null;
    isMobileValid = true;

    setState(() {
      departmentOptions = List.from(defaultDepartmentOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Staff"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField("Employee ID", employeeIdController),
                        _buildTextField("Name", nameController),
                        _buildGenderSelector(),
                        _buildDropdown(
                          "Designation",
                          designationOptions,
                          selectedDesignation,
                          (value) {
                            setState(() {
                              selectedDesignation = value;
                              if (value == 'Principal') {
                                departmentOptions = ['B.Tech', 'Diploma'];
                              } else {
                                departmentOptions =
                                    List.from(defaultDepartmentOptions);
                              }
                              selectedDepartment = null;
                            });
                          },
                        ),
                        _buildDropdown(
                          "Department",
                          departmentOptions,
                          selectedDepartment,
                          (value) => setState(() => selectedDepartment = value),
                        ),
                        _buildTextField("Email", emailController),
                        _buildTextField("Mobile", mobileController,
                            isMobileField: true),
                        _buildTextField("Address", addressController),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: _buildImageSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton.icon(
                  onPressed: handleSubmit,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add", style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isMobileField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: isMobileField ? TextInputType.phone : TextInputType.text,
        focusNode: isMobileField ? mobileFocusNode : null,
        decoration: InputDecoration(
          labelText: label,
          errorText:
              isMobileField && !isMobileValid ? 'Invalid mobile number' : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selected,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedImage != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  selectedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
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
