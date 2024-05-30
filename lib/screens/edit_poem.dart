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
  bool _isLoading = false;

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

  Future<void> _savePoem() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(adminEditPoemProvider({
        'poemId': widget.poemId,
        'title': _titleController.text,
        'content': _contentController.text,
        'author': _authorController.text,
      }).future);
      refreshPoemsProvider(ref);
      context.go('/adminDashboard');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poem saved successfully')),
      );
    } catch (e) {
      print('Failed to save the poem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save the poem. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Poem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter the title',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Enter the content',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                hintText: 'Enter the author',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePoem,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                elevation: 3,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
