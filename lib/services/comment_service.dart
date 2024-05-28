import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {
  final String baseUrl = 'http://10.0.2.2:3000/api/comments';

  Future<void> postComment(String poemId, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? username = prefs.getString('username');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$poemId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
