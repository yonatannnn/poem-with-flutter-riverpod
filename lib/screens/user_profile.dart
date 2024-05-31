import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_profile_provider.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);

    final TextEditingController _usernameController =
        TextEditingController(text: userProfile.username);
    final TextEditingController _emailController =
        TextEditingController(text: userProfile.email);
    final TextEditingController _passwordController = TextEditingController();

    Future<void> _updateUserProfile() async {
      try {
        await userProfileNotifier.updateUserProfile(
          _usernameController.text,
          _emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }

    Future<void> _navigateBasedOnRole() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final role = prefs.getString('role');
        print(role);
        if (role == 'poet') {
          context.go('/adminDashboard');
        } else if (role == 'enthusiast') {
          context.go('/userScreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unknown role')),
          );
        }
      } catch (e) {
        print('Failed to get role: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get role')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            IconButton(
              onPressed: _navigateBasedOnRole,
              icon: Icon(Icons.arrow_back),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
