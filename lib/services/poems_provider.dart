import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'poem_service.dart';

final poemServiceProvider = Provider((ref) => PoemService());


final poemsProvider = FutureProvider<List<dynamic>>((ref) async {
  final poemService = ref.watch(poemServiceProvider);
  return poemService.fetchPoems();
});

void refreshPoemsProvider(WidgetRef ref) {
  ref.refresh(poemsProvider);
}