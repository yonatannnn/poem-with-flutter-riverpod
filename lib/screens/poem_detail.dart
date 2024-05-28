import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/models/poem_model.dart';
import 'package:p/services/comment_provider.dart';
import 'package:p/widgets/comment_field.dart';
import 'package:p/services/comment_service.dart';

class PoemDetailScreen extends ConsumerWidget {
  final Poem poem;

  const PoemDetailScreen({Key? key, required this.poem}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncValue = ref.watch(commentsProvider(poem.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(poem.title),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/userScreen');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poem.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'by ${poem.author}',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            Text(
              poem.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(), // Optional: Add a divider before the comment field
            CommentField(poemId: poem.id),
            SizedBox(height: 20),
            Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            commentsAsyncValue.when(
              data: (comments) => comments.isEmpty
                  ? Text('No comments yet')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['username']),
                          subtitle: Text(comment['comment']),
                        );
                      },
                    ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Failed to load comments')),
            ),
          ],
        ),
      ),
    );
  }
}
