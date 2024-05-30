import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_provider.dart';
import '../services/poems_provider.dart';

class AdminPoemWidget extends ConsumerWidget {
  final String title;
  final String content;
  final String author;
  final String poemId;
  final VoidCallback onDelete;

  AdminPoemWidget(
      {required this.title,
      required this.content,
      required this.author,
      required this.poemId,
      required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _deletePoem() async {
      try {
        await ref.read(adminDeletePoemProvider(poemId).future);
        ref.refresh(adminPoemsProvider);
        context.go('/adminDashboard');
      } catch (e) {
        print('Failed to delete the poem: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete the poem. Please try again.')),
        );
      }
    }

    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              context.go('/admin/edit_poem', extra: {
                'poemId': poemId,
                'title': title,
                'content': content,
                'author': author,
              });
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                onDelete();
              }),
        ],
      ),
    );
  }
}
