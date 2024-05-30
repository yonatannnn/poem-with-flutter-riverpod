import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/services/admin_user_provider.dart';
import '../services/user_provider.dart';
import '../services/admin_provider.dart';

class AdminEditUserScreen extends ConsumerStatefulWidget {
  final String userId;
  final String username;
  final String role;

  AdminEditUserScreen({
    required this.userId,
    required this.username,
    required this.role,
  });

  @override
  _AdminEditUserScreenState createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends ConsumerState<AdminEditUserScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _roleController = TextEditingController(text: widget.role);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _saveUser() async {
    try {
      await ref.read(adminEditUserProvider({
        'userId': widget.userId,
        'username': _usernameController.text,
        'role': _roleController.text,
      }).future);
      ref.refresh(adminUsersProvider);
      context.go('/adminDashboard');
    } catch (e) {
      print('Failed to save the user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save the user. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
