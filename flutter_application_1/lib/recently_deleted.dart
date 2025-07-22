import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecentlyDeletedScreen extends StatefulWidget {
  final String baseUrl;
  final List<Map<String, dynamic>> deletedPeople;
  final Function(Map<String, dynamic>) onRestore;

  const RecentlyDeletedScreen({
    super.key,
    required this.baseUrl,
    required this.deletedPeople,
    required this.onRestore,
  });

  @override
  State<RecentlyDeletedScreen> createState() => _RecentlyDeletedScreenState();
}

class _RecentlyDeletedScreenState extends State<RecentlyDeletedScreen> {
  late List<Map<String, dynamic>> localList;

  @override
  void initState() {
    super.initState();
    localList = List<Map<String, dynamic>>.from(widget.deletedPeople);
    if (localList.isEmpty) {
      fetchDeletedStaff(); // fetch only if empty
    }
  }

  Future<void> fetchDeletedStaff() async {
    final response = await http.get(Uri.parse('${widget.baseUrl}/profiles/deleted/'));
    if (response.statusCode == 200) {
      setState(() {
        localList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load deleted staff');
    }
  }

  Future<void> restoreStaff(Map<String, dynamic> staff) async {
    final id = staff['id'];
    final response = await http.post(Uri.parse('${widget.baseUrl}/profiles/$id/restore/'));

    if (response.statusCode == 200) {
      setState(() {
        localList.removeWhere((element) => element['id'] == id);
      });
      widget.onRestore(staff); // send back to StaffScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Restored successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to restore.")),
      );
    }
  }

  Future<void> permanentlyDeleteStaff(int id) async {
    final response = await http.delete(Uri.parse('${widget.baseUrl}/profiles/$id/permanent_delete/'));

    if (response.statusCode == 204) {
      setState(() {
        localList.removeWhere((element) => element['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permanently deleted.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: ${response.reasonPhrase}")),
      );
    }
  }

  void confirmPermanentDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to permanently delete this record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              permanentlyDeleteStaff(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recently Deleted"),
        backgroundColor: const Color(0xFF899BEF),
        foregroundColor: Colors.white,
      ),
      body: localList.isEmpty
          ? const Center(child: Text("No deleted records."))
          : ListView.builder(
              itemCount: localList.length,
              itemBuilder: (context, index) {
                final person = localList[index];
                final imageUrl = person['image'] != null
                    ? 'http://127.0.0.1:8000${person['image']}'
                    : 'https://i.imgur.com/BoN9kdC.png';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                    title: Text(person['name'] ?? 'Unnamed'),
                    subtitle: Text('ID: ${person['employee_id']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore, color: Colors.green),
                          onPressed: () => restoreStaff(person),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () => confirmPermanentDelete(person['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
