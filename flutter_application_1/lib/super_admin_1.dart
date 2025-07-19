import 'package:flutter/material.dart';

class SuperAdmin1 extends StatefulWidget {
  const SuperAdmin1({super.key});

  @override
  State<SuperAdmin1> createState() => _SuperAdmin1State();
}

class _SuperAdmin1State extends State<SuperAdmin1> {
  final List<Map<String, String>> originalStaffList = [
    {
      'name': 'Person-1',
      'image': 'https://i.imgur.com/BoN9kdC.png',
      'outTime': '01:30',
      'inTime': '02:00',
    },
    {
      'name': 'Person-2',
      'image': 'https://i.imgur.com/2yaf2wb.jpg',
      'outTime': '01:30',
      'inTime': '02:00',
    },
    {
      'name': 'Person-3',
      'image': 'https://i.imgur.com/QCNbOAo.png',
      'outTime': '01:30',
      'inTime': '02:00',
    },
    {
      'name': 'Person-4',
      'image': 'https://i.imgur.com/yXOvdOSs.jpg',
      'outTime': '01:30',
      'inTime': '02:00',
    },
    {
      'name': 'Person-5',
      'image': 'https://i.imgur.com/JSW6mEk.png',
      'outTime': '01:30',
      'inTime': '02:00',
    },
  ];

  List<Map<String, String>> filteredList = [];

  int _selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = List.from(originalStaffList);
  }

  void _onMenuSelected(String value) {
    if (value == 'staff') {
      Navigator.pushNamed(context, '/staff');
    } else if (value == 'register') {
      Navigator.pushNamed(context, '/register');
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      Navigator.pushNamed(context, '/super_admin_2');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/super_admin_account');
    }
  }

  void showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void filterStaffList(String query) {
    final results = originalStaffList.where((staff) {
      final name = staff['name']!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredList = results;
    });
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: TextField(
        controller: searchController,
        onChanged: filterStaffList,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color.fromARGB(255, 244, 244, 246),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 3,
            child: Text('Person Name',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Out Time',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('In Time',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStaffCard(Map<String, String> staff) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => showImageDialog(staff['image']!),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(staff['image']!),
                  radius: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  staff['name']!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(staff['outTime']!, style: const TextStyle(fontSize: 14)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(staff['inTime']!, style: const TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${staff['name']} Accepted')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${staff['name']} Declined')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Decline'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStaffList() {
    return ListView(
      children: [
        const SizedBox(height: 10),
        buildSearchBar(),
        if (filteredList.isNotEmpty) ...[
          buildHeaderRow(),
          const Divider(thickness: 1, color: Colors.grey),
          ...filteredList.map((staff) => buildStaffCard(staff)).toList(),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Text(
                'Results not found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Super Admin'),
        backgroundColor: const Color(0xFF6A85B6),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'staff', child: Text('Staff')),
              const PopupMenuItem(value: 'register', child: Text('Register')),
            ],
          ),
        ],
      ),
      body: SafeArea(child: buildStaffList()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF6A85B6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
