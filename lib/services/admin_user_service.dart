import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminUserService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Map<String, dynamic>>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('inside getUsers');
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateUser(String userId, String username, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('$baseUrl/api/users/$userId');
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'role': role,
      }),
    );
    print("response body = ");
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('$baseUrl/api/users/$userId');
    final response = await http.delete(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> addUser(String username, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 201) {
      print('User added successfully');
    } else {
      throw Exception('Failed to add user');
    }
  }
}
