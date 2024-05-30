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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Poem saved successfully', style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to save the poem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save the poem. Please try again.',
              style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Poem'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter the title',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Enter the content',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                hintText: 'Enter the author',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePoem,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[900],
                elevation: 3,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
