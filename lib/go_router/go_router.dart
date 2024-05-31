import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/models/poem_model.dart';
import 'package:p/screens/favorite_screen.dart';
import 'package:p/screens/user_profile.dart';
import 'package:p/screens/user_screen.dart';
import 'package:p/widgets/poems_list.dart';
import 'package:p/widgets/user_favourite_poem.dart';
import '../screens/login_page.dart';
import '../screens/signup.dart';
import '../screens/welcome.dart';
import '../models/user_model.dart';
import '../screens/user_screen.dart';
import '../screens/poem_detail.dart';
import '../screens/about.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/userScreen',
        builder: (context, state) => poemsScreenPage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const About(),
      ),
      GoRoute(
        path: '/poem-detail',
        builder: (context, state) {
          final Poem poem = state.extra as Poem;
          return PoemDetailScreen(poem: poem);
        },
      ),
      GoRoute(
        path: '/favorite_screen',
        builder: (context, state) => FavoriteScreen(),
      ),
      GoRoute(
        path: '/user_profile_screen',
        builder: (context, state) => UserProfile(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
    ],
  );
});
