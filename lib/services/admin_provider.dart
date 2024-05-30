import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/admin_poem_Service.dart';
import 'package:http/http.dart' as http;

// Provider for SharedPreferences
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Provider for AdminPoemService
final adminPoemServiceProvider = FutureProvider<AdminPoemService>((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  final client = http.Client();
  return AdminPoemService(
    client: client,
    sharedPreferences: sharedPreferences,
  );
});

// Provider for getting poems
final adminPoemsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final adminPoemService = await ref.watch(adminPoemServiceProvider.future);
  return adminPoemService.getPoems();
});

// Provider for updating a poem
final adminEditPoemProvider =
    FutureProvider.family<void, Map<String, String>>((ref, poemData) async {
  final adminPoemService = await ref.watch(adminPoemServiceProvider.future);
  await adminPoemService.updatePoem(poemData['poemId']!, poemData['title']!,
      poemData['content']!, poemData['author']!);
});

// Provider for deleting a poem
final adminDeletePoemProvider =
    FutureProvider.family<void, String>((ref, poemId) async {
  final adminPoemService = await ref.watch(adminPoemServiceProvider.future);
  await adminPoemService.deletePoem(poemId);
});

// Provider for adding a poem
final adminAddPoemProvider =
    FutureProvider.family<void, Map<String, String>>((ref, poemData) async {
  final adminPoemService = await ref.watch(adminPoemServiceProvider.future);
  await adminPoemService.addPoem(
      poemData['title']!, poemData['content']!, poemData['author']!);
});
