import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/models/poem_model.dart';
import 'package:p/services/favorite_provider.dart';
import 'package:p/services/favorite_service.dart';

class UserFavoritePeomWidget extends ConsumerWidget {
  final String title;
  final String content;
  final String author;
  final String poemId;

  const UserFavoritePeomWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.author,
    required this.poemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteService = ref.read(favoriteServiceProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          context.go('/poem-detail', extra: {
            'title': title,
            'content': content,
            'poem': Poem(
              title: title,
              content: content,
              author: author,
              id: poemId,
              genre: 'General',
            ),
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]!),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  author,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, size: 40),
                  onPressed: () async {
                    try {
                      await favoriteService.addFavorite(poemId);
    
                    } catch (e) {
                      
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to add favorite: $e'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, size: 40),
                  onPressed: () async {
                    try {
                      await favoriteService.removeFavorite(poemId);
                      
                    } catch (e) {
                      
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to remove favorite: $e'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
