import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  final String baseUrl = 'http://10.0.2.2:3000/api/favorites';

  Future<List<dynamic>> fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFavorite(String poemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'PoemId': poemId}),
      );
      print(response.statusCode);
      if (response.statusCode != 201) {
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavorite(String poemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$poemId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove favorite');
      }
      print(response.statusCode);
    } catch (e) {
      print('Error removing favorite: $e');
      throw Exception('Failed to remove favorite');
    }
  }
}
