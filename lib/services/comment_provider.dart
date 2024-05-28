import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/comment_service.dart';

final commentServiceProvider = Provider<CommentService>((ref) {
  return CommentService();
});

final commentControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});


final commentsProvider = FutureProvider.family<List<dynamic>, String>((ref, poemId) async {
  final commentService = ref.read(commentServiceProvider);
  return await commentService.fetchComments(poemId);
});
