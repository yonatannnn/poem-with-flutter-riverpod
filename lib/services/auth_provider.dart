import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_response.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthResponse?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthResponse?> {
  AuthNotifier() : super(null);

  Future<void> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://yourapi.com/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      state = AuthResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  void signOut() {
    state = null;
  }
}
