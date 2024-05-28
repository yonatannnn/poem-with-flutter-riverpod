import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/comment_provider.dart';
import 'package:p/services/comment_service.dart';

class CommentField extends ConsumerWidget {
  final String poemId;

  CommentField({required this.poemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _commentController = ref.watch(commentControllerProvider);
    final commentService = ref.watch(commentServiceProvider);

    void _postComment() async {
      String comment = _commentController.text.trim();
      if (comment.isNotEmpty) {
        try {
          await commentService.postComment(poemId, comment);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Comment posted successfully'),
            duration: Duration(seconds: 2),
          ));
          _commentController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to post comment: $e'),
            duration: Duration(seconds: 2),
          ));
        }
      }
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _postComment,
          child: Text('Post'),
        ),
      ],
    );
  }
}
