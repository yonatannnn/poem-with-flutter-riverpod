import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http; // Ensure this path is correct
import 'package:p/services/admin_poem_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mocks.mocks.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockClient extends Mock implements http.Client {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MockClient mockClient;
  late AdminPoemService adminPoemService;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockClient = MockClient();
    adminPoemService = AdminPoemService(
        client: mockClient, sharedPreferences: mockSharedPreferences);
  });

  group('AdminPoemService Tests', () {
    test('getPoems returns a list of poems', () async {
      final poems = [
        {'id': '1', 'title': 'Test Poem', 'content': 'This is a test poem'},
      ];

      when(mockSharedPreferences.getString('token')).thenReturn('fake_token');
      when(mockClient.get(
        Uri.parse('http://10.0.2.2:3000/api/poems'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(poems), 200));
      

      final result = await adminPoemService.getPoems();
      print(result);
      expect(result, poems);
    });

    test('getPoems throws an exception on failure', () async {
      when(mockSharedPreferences.getString('token')).thenReturn('fake_token');
      when(mockClient.get(
        Uri.parse('http://10.0.2.2:3000/api/poems'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 401));

      expect(() async => await adminPoemService.getPoems(), throwsException);
    });

    // Add other test cases for addPoem, updatePoem, deletePoem...
  });
}
