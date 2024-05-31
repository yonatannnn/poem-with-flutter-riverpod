import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/services/admin_provider.dart';
import 'package:p/services/poems_provider.dart';

class AddPoemScreen extends ConsumerStatefulWidget {
  @override
  _AddPoemScreenState createState() => _AddPoemScreenState();
}

class _AddPoemScreenState extends ConsumerState<AddPoemScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _authorController = TextEditingController();
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
      await ref.read(adminAddPoemProvider({
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
      appBar: AppBar(title: Text('Add Poem')),
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
