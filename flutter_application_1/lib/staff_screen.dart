import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'update_staff_screen.dart';

class StaffScreen extends StatefulWidget {
  final String baseUrl;

  const StaffScreen({super.key, required this.baseUrl});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> staffList = [];
  List<Map<String, dynamic>> recentlyDeleted = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchStaff();
    fetchDeletedStaff();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchStaff() async {
    final response = await http.get(Uri.parse('${widget.baseUrl}/profiles/'));
    if (response.statusCode == 200) {
      setState(() {
        staffList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load staff: ${response.statusCode}');
    }
  }

  Future<void> fetchDeletedStaff() async {
    final response = await http.get(Uri.parse('${widget.baseUrl}/profiles/deleted/'));
    if (response.statusCode == 200) {
      setState(() {
        recentlyDeleted = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load deleted staff: ${response.statusCode}');
    }
  }

  Future<void> deleteStaff(int id) async {
    final response = await http.delete(Uri.parse('${widget.baseUrl}/profiles/$id/'));
    if (response.statusCode == 204) {
      final deleted = staffList.firstWhere((e) => e['id'] == id);
      setState(() {
        staffList.removeWhere((e) => e['id'] == id);
        recentlyDeleted.add(deleted);
      });
      _tabController.animateTo(1); // Navigate to deleted tab
    } else {
      print('Delete failed: ${response.statusCode}');
    }
  }

  Future<void> restoreStaff(int id) async {
    final response = await http.post(Uri.parse('${widget.baseUrl}/profiles/$id/restore/'));
    if (response.statusCode == 200) {
      final restored = recentlyDeleted.firstWhere((e) => e['id'] == id);
      setState(() {
        recentlyDeleted.removeWhere((e) => e['id'] == id);
        staffList.add(restored);
      });
      _tabController.animateTo(0); // Navigate back to active staff
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
          backgroundColor: const Color(0xFF6A85B6),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Active Staff'),
              Tab(text: 'Recently Deleted'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
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
        return _buildStaffCard(staff, isDeleted: false);
      },
    );
  }

  Widget _buildDeletedList() {
    return ListView.builder(
      itemCount: recentlyDeleted.length,
      itemBuilder: (context, index) {
        final staff = recentlyDeleted[index];
        return _buildStaffCard(staff, isDeleted: true);
      },
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff, {required bool isDeleted}) {
    final imageUrl = staff['image'] != null
        ? 'http://127.0.0.1:8000${staff['image']}'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: imageUrl != null
            ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUrl),
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
          children: isDeleted
              ? [
                  IconButton(
                    icon: const Icon(Icons.restore, color: Colors.green),
                    onPressed: () => restoreStaff(staff['id']),
                  ),
                ]
              : [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateStaffScreen(
                            staffMember: Map<String, String>.from(
                              staff.map((k, v) => MapEntry(k.toString(), v.toString())),
                            ),
                            baseUrl: widget.baseUrl,
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
  }
}
