import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/services/poems_provider.dart';
import '../services/admin_provider.dart';

class AdminEditPoemScreen extends ConsumerStatefulWidget {
  final String poemId;
  final String title;
  final String content;
  final String author;

  AdminEditPoemScreen({
    required this.poemId,
    required this.title,
    required this.content,
    required this.author,
  });

  @override
  _AdminEditPoemScreenState createState() => _AdminEditPoemScreenState();
}

class _AdminEditPoemScreenState extends ConsumerState<AdminEditPoemScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _authorController = TextEditingController(text: widget.author);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _savePoem() async {
    try {
      await ref.read(adminEditPoemProvider({
        'poemId': widget.poemId,
        'title': _titleController.text,
        'content': _contentController.text,
        'author': _authorController.text,
      }).future);
      refreshPoemsProvider(ref);
      context.go('/adminDashboard');
    } catch (e) {
      print('Failed to save the poem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save the poem. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Poem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePoem,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
