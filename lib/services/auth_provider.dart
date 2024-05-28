import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../go_router/go_router.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(AuthState());

  final Ref _ref;

  Future<void> register(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = AuthResponse.fromJson(data).user;
        state = AuthState(user: user);
      } else {
        final data = json.decode(response.body);
        state = AuthState(errorMessage: data['message']);
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    state = AuthState(isLoading: true);
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('token', data['token']);
        prefs.setString('username', data['user']['username']);
        prefs.setString('user_email', data['user']['email']);
        final user = AuthResponse.fromJson(data).user;
        print(user.role);
        state = AuthState(user: user);
        final goRouter = _ref.read(goRouterProvider);
        if (user.role == 'admin') {
          goRouter.go('/adminDashboard');
        } else if (user.role == 'enthusiast') {
          goRouter.go('/userScreen', extra: user);
        } else {
          goRouter.go('/');
        }
      } else {
        final data = json.decode(response.body);
        state = AuthState(errorMessage: data['message']);
      }
    } catch (e) {
      print('outside try block');
      state = AuthState(errorMessage: e.toString());
    }
  }

  void logout() {
    state = AuthState();
  }
}
