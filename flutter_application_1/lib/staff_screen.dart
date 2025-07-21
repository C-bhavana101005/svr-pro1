import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'update_staff_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  List<dynamic> staffList = [];
  List<dynamic> recentlyDeleted = [];

  final String baseHost = kIsWeb ? '127.0.0.1' : '10.0.2.2';
  late final String baseUrl;

  @override
  void initState() {
    super.initState();
    baseUrl = 'http://$baseHost:8000/api';
    fetchStaff();
    fetchDeletedStaff();
  }

  Future<void> fetchStaff() async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/'));
    if (response.statusCode == 200) {
      setState(() {
        staffList = json.decode(response.body);
      });
    } else {
      print('Failed to load staff: ${response.statusCode}');
    }
  }

  Future<void> fetchDeletedStaff() async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/deleted/'));
    if (response.statusCode == 200) {
      setState(() {
        recentlyDeleted = json.decode(response.body);
      });
    } else {
      print('Failed to load deleted staff: ${response.statusCode}');
    }
  }

  Future<void> deleteStaff(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/profiles/$id/'));
    if (response.statusCode == 204) {
      fetchStaff();
      fetchDeletedStaff();
    } else {
      print('Delete failed: ${response.statusCode}');
    }
  }

  Future<void> restoreStaff(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/profiles/$id/restore/'));
    if (response.statusCode == 200) {
      fetchStaff();
      fetchDeletedStaff();
    } else {
      print('Restore failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Staff List"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Staff'),
              Tab(text: 'Recently Deleted'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStaffList(),
            _buildDeletedList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    return ListView.builder(
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            leading: staff['image'] != null
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('http://$baseHost:8000${staff['image']}'),
                  )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text('${staff['name']} (${staff['employee_id']})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${staff['designation']} - ${staff['department']}'),
                Text('Email: ${staff['email']}'),
                Text('Mobile: ${staff['mobile']}'),
                Text('Address: ${staff['address']}'),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateStaffScreen(
                          staffMember: Map<String, String>.from(
                            staff.map((key, value) => MapEntry(key.toString(), value.toString())),
                          ),
                          baseUrl: baseUrl,
                          onUpdate: fetchStaff,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteStaff(staff['id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeletedList() {
    return ListView.builder(
      itemCount: recentlyDeleted.length,
      itemBuilder: (context, index) {
        final staff = recentlyDeleted[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            leading: staff['image'] != null
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('http://$baseHost:8000${staff['image']}'),
                  )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text('${staff['name']} (${staff['employee_id']})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${staff['designation']} - ${staff['department']}'),
                Text('Email: ${staff['email']}'),
                Text('Mobile: ${staff['mobile']}'),
                Text('Address: ${staff['address']}'),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.restore, color: Colors.green),
              onPressed: () => restoreStaff(staff['id']),
            ),
          ),
        );
      },
    );
  }
}
