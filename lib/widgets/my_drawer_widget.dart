import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/user_provider.dart';
import '../go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 111, 191, 215),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          userAsyncValue.when(
            data: (userData) => UserAccountsDrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 127, 16, 196)),
              accountName: Text(userData['name'] ?? 'User'),
              accountEmail: Text(userData['email'] ?? 'email@example.com'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text('Failed to load user data')),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About us'),
            onTap: () {
              context.go('/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact us'),
            onTap: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear all data from SharedPreferences
              context.go('/login'); // Navigate to the login page
            },
          ),
        ],
      ),
    );
  }
}
