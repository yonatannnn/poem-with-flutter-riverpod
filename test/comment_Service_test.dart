import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../lib/services/admin_poem_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/services/comment_service.dart';

import 'mocks.mocks.dart';

void main() {
  late CommentService commentService;
  late MockSharedPreferences mockSharedPreferences;
  late MockClient mockClient;
  late AdminPoemService adminPoemService;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockClient = MockClient();
    commentService = CommentService(
      baseUrl: 'http://10.0.2.2:3000/api/comments',
      client: mockClient,
      sharedPreferences: mockSharedPreferences,
    );
    adminPoemService = AdminPoemService(
      client: mockClient,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('CommentService', () {
    test('fetchComments returns a list of comments', () async {
      final poemId = '1';
      final comments = [
        {'username': 'user1', 'comment': 'Nice poem!'},
      ];

      when(mockSharedPreferences.getString('token')).thenReturn('fake_token');
      when(mockClient.get(
        Uri.parse('http://10.0.2.2:3000/api/comments/$poemId'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(comments), 200));

      final result = await commentService.fetchComments(poemId);

      expect(result, comments);
    });

    test('postComment sends a POST request', () async {
      final poemId = '1';
      final comment = 'Nice poem!';
      final username = 'user1';

      when(mockSharedPreferences.getString('token')).thenReturn('fake_token');
      when(mockSharedPreferences.getString('username')).thenReturn(username);
      when(mockClient.post(
        Uri.parse('http://10.0.2.2:3000/api/comments'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 201));

      await commentService.postComment(poemId, comment);

      verify(mockClient.post(
        Uri.parse('http://10.0.2.2:3000/api/comments'),
        headers: {
          'Authorization': 'Bearer fake_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'comment': comment,
          'poemId': poemId,
        }),
      )).called(1);
    });
  });
}
