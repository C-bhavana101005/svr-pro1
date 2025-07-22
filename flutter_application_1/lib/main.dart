import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'splash_screen.dart';
import 'login_screen.dart';
import 'super_admin_1.dart';
import 'super_admin_2.dart';
import 'super_admin_account.dart';
import 'register_screen.dart';
import 'staff_screen.dart';
import 'recently_deleted.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String baseHost = kIsWeb ? '127.0.0.1' : '10.0.2.2';
    final String baseUrl = 'http://$baseHost:8000/api';

    return MaterialApp(
      title: 'SVR College',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/super_admin_1': (context) => const SuperAdmin1(),
        '/super_admin_2': (context) => const SuperAdmin2(),
        '/super_admin_account': (context) => const SuperAdminAccount(),
        '/register': (context) => const RegisterScreen(),
        '/staff': (context) => StaffScreen(baseUrl: baseUrl),
        '/recently_deleted': (context) => RecentlyDeletedScreen(
              baseUrl: baseUrl,
              deletedPeople: const [], // replace with actual list if needed
              onRestore: (person) {},  // dummy function, can update with real logic
            ),
      },
    );
  }
}
