import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/screens/user_screen.dart';
import '../screens/login_page.dart';
import '../screens/signup.dart';
import '../screens/welcome.dart';
import '../models/user_model.dart';
import '../screens/user_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Welcome(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/poemScreen',
        builder: (context, state) => poemsScreen(),
      ),
    ],
  );
});
