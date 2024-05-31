import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/widgets/user_widget.dart';
import '../widgets/user_widget.dart';
import '../services/admin_user_provider.dart';

class AdminUsersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(adminUsersProvider);
            },
          ),
        ],
      ),
      body: usersAsyncValue.when(
        data: (users) => users.isEmpty
            ? Center(child: Text('No users found'))
            : ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return AdminUserWidget(
                    username: user['username'],
                    email: user['email'],
                    userId: user['_id'],
                    role: user['role'],
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
