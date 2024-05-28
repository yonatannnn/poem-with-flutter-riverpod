import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/widgets/profile_widget.dart';
import '../widgets/poems_list.dart';

class poemsScreenPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poems',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Profile(),
            SizedBox(height: 20),
            Expanded(child: PoemsScreen()),
          ],
        ),
      ),
    );
  }
}
