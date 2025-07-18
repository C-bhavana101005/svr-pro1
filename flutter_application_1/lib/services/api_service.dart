import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  // Use '10.0.2.2' for Android emulator, '127.0.0.1' for browser/desktop.
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Register a new staff member
  static Future<void> registerStaff({
    required String empId,
    required String name,
    required String gender,
    required String designation,
    required String department,
    required String email,
    required String mobile,
    required String address,
    required Uint8List imageBytes,
    required String filename,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profiles/'));

    request.fields['employee_id'] = empId;
    request.fields['name'] = name;
    request.fields['gender'] = gender;
    request.fields['designation'] = designation;
    request.fields['department'] = department;
    request.fields['email'] = email;
    request.fields['mobile'] = mobile;
    request.fields['address'] = address;

    request.files.add(http.MultipartFile.fromBytes(
      'photo',
      imageBytes,
      filename: filename,
    ));

    var response = await request.send();

    if (response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Failed to register staff: ${response.statusCode} - $respStr');
    }
  }

  /// Fetch all active staff members (is_deleted = false)
  static Future<List<Map<String, dynamic>>> fetchStaffList() async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch staff list');
    }
  }

  /// Soft delete a staff member by ID (sets is_deleted = true)
  static Future<void> deleteStaff(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/profiles/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete staff');
    }
  }

  /// Fetch all soft-deleted staff members (is_deleted = true)
  static Future<List<Map<String, dynamic>>> fetchDeletedStaff() async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/deleted/'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch deleted staff list');
    }
  }

  /// Restore a soft-deleted staff member by ID (sets is_deleted = false)
  static Future<void> restoreStaff(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/profiles/$id/restore/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to restore staff');
    }
  }

  /// Update staff fields (Optional - PATCH request)
  static Future<void> updateStaff(int id, Map<String, dynamic> updatedFields) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/profiles/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedFields),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update staff');
    }
  }
}
