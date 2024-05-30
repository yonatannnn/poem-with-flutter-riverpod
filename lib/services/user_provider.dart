import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs);
  String name = prefs.getString('username') ?? 'User';
  String email = prefs.getString('user_email') ?? 'jonathan@gmail.com';
  return {'name': name, 'email': email};
}

final userProvider = FutureProvider<Map<String, String>>((ref) async {
  return await loadUserData();
});
