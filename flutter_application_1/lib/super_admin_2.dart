import 'package:flutter/material.dart';

class SuperAdmin2 extends StatefulWidget {
  const SuperAdmin2({super.key});

  @override
  State<SuperAdmin2> createState() => _SuperAdmin2State();
}

class _SuperAdmin2State extends State<SuperAdmin2> {
  int _selectedIndex = 1;

  final List<Map<String, String>> reportData = [
    {
      'sno': '1',
      'name': 'Person-1',
      'outTime': '01:30',
      'inTime': '02:00',
      'review': '-----',
      'date': '01-02-25',
    },
    {
      'sno': '2',
      'name': 'Person-2',
      'outTime': '01:30',
      'inTime': '02:00',
      'review': '-----',
      'date': '02-02-25',
    },
    {
      'sno': '3',
      'name': 'Person-3',
      'outTime': '01:30',
      'inTime': '02:00',
      'review': '-----',
      'date': '03-02-25',
    },
    {
      'sno': '4',
      'name': 'Person-4',
      'outTime': '01:30',
      'inTime': '02:00',
      'review': '-----',
      'date': '04-02-25',
    },
    {
      'sno': '5',
      'name': 'Person-5',
      'outTime': '01:30',
      'inTime': '02:00',
      'review': '-----',
      'date': '05-02-25',
    },
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.pushNamed(context, '/super_admin_1');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/super_admin_account');
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A85B6), Color.fromARGB(255, 177, 204, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: const [
            SizedBox(width: 12),
            Icon(Icons.search, color: Colors.black54),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 230, 230, 250)),
        border: TableBorder.all(color: Colors.grey.shade400),
        columns: const [
          DataColumn(label: Text('S.no')),
          DataColumn(label: Text('Person Name')),
          DataColumn(label: Text('Out Time')),
          DataColumn(label: Text('In Time')),
          DataColumn(label: Text('Review')),
          DataColumn(label: Text('Date')),
        ],
        rows: reportData.map((row) {
          return DataRow(cells: [
            DataCell(Text(row['sno']!)),
            DataCell(Text(row['name']!)),
            DataCell(Text(row['outTime']!)),
            DataCell(Text(row['inTime']!)),
            DataCell(Text(row['review']!)),
            DataCell(Text(row['date']!)),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: buildReportTable(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 106, 133, 182),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(115, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
