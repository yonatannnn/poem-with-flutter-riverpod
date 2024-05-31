import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_user_provider.dart';

class AdminUserWidget extends ConsumerWidget {
  final String username;
  final String email;
  final String userId;
  final String role;

  AdminUserWidget({
    required this.username,
    required this.email,
    required this.userId,
    required this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _deleteUser() async {
      try {
        await ref.read(adminDeleteUserProvider(userId).future);
        ref.refresh(adminUsersProvider);
        context.go('/adminDashboard');
      } catch (e) {
        print('Failed to delete the user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete the user. Please try again.')),
        );
      }
    }

    return ListTile(
      title: Text(username),
      subtitle: Text(email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              context.go('/admin/edit_user', extra: {
                'userId': userId,
                'username': username,
                'role': role,
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteUser,
          ),
        ],
      ),
    );
  }
}
