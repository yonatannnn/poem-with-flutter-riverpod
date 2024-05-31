import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/user_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_Service.dart';

final userProfileServiceProvider = Provider((ref) => UserProfileService());

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier(ref.read(userProfileServiceProvider));
});

class UserProfile {
  final String id;
  final String username;
  final String email;

  UserProfile({required this.id, required this.username, required this.email});
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  final UserProfileService _service;

  UserProfileNotifier(this._service)
      : super(UserProfile(id: '', username: '', email: '')) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserProfile(
      id: prefs.getString('user_id') ?? '',
      username: prefs.getString('username') ?? 'User',
      email: prefs.getString('user_email') ?? 'email',
    );
  }

  Future<void> updateUserProfile(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    print('username $username email $email');
    await _service.updateUserProfile(state.id, username, email);
    state = UserProfile(id: state.id, username: username, email: email);

    // Update the SharedPreferences after the state is updated
    await prefs.setString('username', username);
    await prefs.setString('user_email', email);
  }
}
