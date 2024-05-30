import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/user_favourite_poem.dart';
import '../services/favorite_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsyncValue = ref.watch(fetchFavoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoritesAsyncValue.when(
        data: (favorites) => favorites.isEmpty
            ? Center(child: Text('No favorite poems found'))
            : ListView.separated(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final poem = favorites[index];
                  return UserPoemWidget(
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
