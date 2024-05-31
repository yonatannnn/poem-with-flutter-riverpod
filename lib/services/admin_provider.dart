import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_poem_Service.dart';

final adminPoemServiceProvider = Provider((ref) => AdminPoemService());

final adminPoemsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final adminPoemService = ref.read(adminPoemServiceProvider);
  return adminPoemService.getPoems();
});

final adminEditPoemProvider =
    FutureProvider.family<void, Map<String, String>>((ref, poemData) async {
  final adminPoemService = ref.read(adminPoemServiceProvider);
  await adminPoemService.updatePoem(poemData['poemId']!, poemData['title']!,
      poemData['content']!, poemData['author']!);
});

final adminDeletePoemProvider =
    FutureProvider.family<void, String>((ref, poemId) async {
  final adminPoemService = ref.read(adminPoemServiceProvider);
  await adminPoemService.deletePoem(poemId);
});

final adminAddPoemProvider =
    FutureProvider.family<void, Map<String, String>>((ref, poemData) async {
  final adminPoemService = ref.read(adminPoemServiceProvider);
  await adminPoemService.addPoem(
      poemData['title']!, poemData['content']!, poemData['author']!);
});
