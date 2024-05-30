import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorite_service.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  return FavoriteService();
});

final fetchFavoritesProvider = FutureProvider<List<dynamic>>((ref) async {
  final favoriteService = ref.read(favoriteServiceProvider);
  return favoriteService.fetchFavorites();
});

final addFavoriteProvider =
    FutureProvider.family<void, String>((ref, poemId) async {
  final favoriteService = ref.read(favoriteServiceProvider);
  await favoriteService.addFavorite(poemId);
  ref.refresh(fetchFavoritesProvider);
});

final removeFavoriteProvider =
    FutureProvider.family<void, String>((ref, poemId) async {
  final favoriteService = ref.read(favoriteServiceProvider);
  await favoriteService.removeFavorite(poemId);
  ref.refresh(fetchFavoritesProvider);
});
