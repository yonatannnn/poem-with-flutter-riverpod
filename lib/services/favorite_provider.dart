import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p/services/favorite_service.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  return FavoriteService();
});

final favoritesProvider = FutureProvider<List<dynamic>>((ref) async {
  final favoriteService = ref.read(favoriteServiceProvider);
  return await favoriteService.fetchFavorites();
});
