import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/favorite_provider.dart';
import 'package:p/widgets/user_favourite_poem.dart';
import 'package:p/widgets/user_poem_widget.dart';
import 'package:p/services/favorite_service.dart';

class FavouriteScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsyncValue = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Poems'),
        backgroundColor: Colors.blue[900],
      ),
      body: favoritesAsyncValue.when(
        data: (favorites) => favorites.isEmpty
            ? Center(child: Text('No favorite poems found'))
            : ListView.separated(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final poem = favorites[index];
                  return UserFavoritePeomWidget(
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
