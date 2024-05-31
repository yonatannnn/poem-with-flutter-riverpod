import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdminPoemService {
  final String baseUrl = 'http://10.0.2.2:3000';
  Future<List<Map<String, dynamic>>> getPoems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('inside getPoems');
    final response = await http.get(
      Uri.parse('$baseUrl/api/poems'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization ': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load poems');
    }
  }

  Future<void> updatePoem(
      String poemId, String title, String content, String author) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('${baseUrl}/api/poems/${poemId}');
    final response = await http.put(
      Uri.parse('$baseUrl/api/poems/$poemId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
        'author': author,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to update poem');
    }
  }

  Future<void> deletePoem(String poemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('${baseUrl}/api/poems/${poemId}');
    final response = await http.delete(
      Uri.parse('$baseUrl/api/poems/$poemId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete poem');
    }
  }

  Future<void> addPoem(String title, String content, String author) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/poems'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
        'author': author,
        'genre': 'General'
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Poem added successfully');
    } else {
      throw Exception('Failed to add poem');
    }
  }
}
