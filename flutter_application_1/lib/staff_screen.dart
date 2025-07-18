import 'package:flutter/material.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  List<Map<String, String>> staffList = [
    {
      'id': 'E101',
      'name': 'Alice',
      'designation': 'Professor',
      'department': 'CSE',
    },
    {
      'id': 'E102',
      'name': 'Bob',
      'designation': 'Assistant Professor',
      'department': 'ECE',
    },
  ];

  List<Map<String, String>> recentlyDeleted = [];

  void deleteStaff(int index) {
    setState(() {
      recentlyDeleted.add(staffList[index]);
      staffList.removeAt(index);
    });
  }

  void restoreStaff(int index) {
    setState(() {
      staffList.add(recentlyDeleted[index]);
      recentlyDeleted.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Staff List"),
          bottom: const TabBar(tabs: [
            Tab(text: 'Active Staff'),
            Tab(text: 'Recently Deleted'),
          ]),
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
        return ListTile(
          title: Text('${staff['name']} (${staff['id']})'),
          subtitle: Text('${staff['designation']} - ${staff['department']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Navigate to UpdateScreen (not connected to backend)
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteStaff(index),
              ),
            ],
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
        return ListTile(
          title: Text('${staff['name']} (${staff['id']})'),
          subtitle: Text('${staff['designation']} - ${staff['department']}'),
          trailing: IconButton(
            icon: const Icon(Icons.restore, color: Colors.green),
            onPressed: () => restoreStaff(index),
          ),
        );
      },
    );
  }
}
