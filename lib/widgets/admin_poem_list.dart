import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/admin_provider.dart';
import 'package:p/services/poems_provider.dart';
import '../widgets/admin_poem_widget.dart';

class AdminPoemsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poemsAsyncValue = ref.watch(poemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Poems'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(adminPoemsProvider);
            },
          ),
        ],
      ),
      body: poemsAsyncValue.when(
        data: (poems) => poems.isEmpty
            ? Center(child: Text('No poems found'))
            : ListView.separated(
                itemCount: poems.length,
                itemBuilder: (context, index) {
                  final poem = poems[index];
                  return AdminPoemWidget(
                    title: poem['title'],
                    content: poem['content'],
                    author: poem['author'],
                    poemId: poem['_id'],
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
