import 'package:flutter/material.dart';

class RecentlyDeletedScreen extends StatefulWidget {
  final List<Map<String, dynamic>> deletedPeople;
  final Function(Map<String, dynamic>) onRestore;

  const RecentlyDeletedScreen({
    super.key,
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
  }

  void restore(int index) {
    final person = localList.removeAt(index);
    widget.onRestore(person);
    setState(() {});
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
                final imageUrl = person['image'] ?? 'https://i.imgur.com/BoN9kdC.png';
                final name = person['name'] ?? 'Unnamed';

                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                  title: Text(name),
                  trailing: ElevatedButton(
                    onPressed: () => restore(index),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Restore", style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
    );
  }
}
