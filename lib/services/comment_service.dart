import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {
  final String baseUrl;
  final http.Client client;
  final SharedPreferences sharedPreferences;

  CommentService({
    required this.baseUrl,
    required this.client,
    required this.sharedPreferences,
  });

  Future<void> postComment(String poemId, String comment) async {
    String? token = sharedPreferences.getString('token');
    String? username = sharedPreferences.getString('username');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'comment': comment,
        'poemId': poemId,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post comment');
    }
  }

  Future<List<dynamic>> fetchComments(String poemId) async {
    String? token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/$poemId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
