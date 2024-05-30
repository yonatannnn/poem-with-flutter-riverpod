import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'comment_service.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final commentServiceProvider = FutureProvider<CommentService>((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  final client = http.Client();

  return CommentService(
    baseUrl: 'http://10.0.2.2:3000/api/comments',
    client: client,
    sharedPreferences: sharedPreferences,
  );
});

final commentControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final commentsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, poemId) async {
  final commentService = await ref.watch(commentServiceProvider.future);
  return await commentService.fetchComments(poemId);
});
