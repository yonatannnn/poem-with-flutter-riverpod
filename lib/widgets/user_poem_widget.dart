import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/services/favorite_provider.dart';
import '../models/poem_model.dart';
import '../services/favorite_provider.dart';

class UserPoemWidget extends ConsumerWidget {
  final String title;
  final String content;
  final String author;
  final String poemId;

  const UserPoemWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.author,
    required this.poemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteProvider = FutureProvider<bool>((ref) async {
      final favorites = await ref.read(fetchFavoritesProvider.future);
      return favorites.any((poem) => poem['_id'] == poemId);
    });

    final isFavorite = ref.watch(isFavoriteProvider).when(
          data: (data) => data,
          loading: () => false,
          error: (_, __) => false,
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          context.go(
            '/poem-detail',
            extra: Poem(
              title: title,
              content: content,
              author: author,
              id: poemId,
              genre: 'General',
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]!),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
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
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 40,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () async {
                    if (isFavorite) {
                      print('in_is_favorite');
                      await ref.read(addFavoriteProvider(poemId).future);
                    } else {
                      print('in_not_favorite');
                      await ref
                          .read(favoriteServiceProvider)
                          .addFavorite(poemId);
                    }
                    ref.refresh(fetchFavoritesProvider);
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
