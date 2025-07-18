import 'package:flutter/material.dart';

class SuperAdminAccount extends StatefulWidget {
  const SuperAdminAccount({super.key});

  @override
  State<SuperAdminAccount> createState() => _SuperAdminAccountState();
}

class _SuperAdminAccountState extends State<SuperAdminAccount> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.pushNamed(context, '/super_admin_1');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/super_admin_2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top AppBar Section
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3366FF), Color(0xFF7F99FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Profile Section
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFCCCCFF),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit profile image",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          // Info Section
          buildProfileItem('Name', 'Helena Hills'),
          buildProfileItem('User Name', '@username'),
          buildProfileItem('Email', 'name@domin.com'),

          const Spacer(),

          // Log Out Section
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.blue),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
              onTap: () {
                // Handle logout logic
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 200, 200, 255),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: 'reports'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'account'),
        ],
      ),
    );
  }

  Widget buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.edit, size: 18, color: Color.fromARGB(115, 168, 28, 28)),
        ],
      ),
    );
  }
}
