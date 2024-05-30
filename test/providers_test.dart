import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../lib/services/comment_provider.dart'; // Adjust the import to your project's structure
import '../lib/services/comment_service.dart';

import 'mocks.mocks.dart'; // Import the generated mocks

void main() {
  late ProviderContainer container;
  late MockSharedPreferences mockSharedPreferences;
  late MockClient mockClient;
  late CommentService mockCommentService;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockClient = MockClient();
    mockCommentService = CommentService(
      baseUrl: 'http://10.0.2.2:3000/api/comments',
      client: mockClient,
      sharedPreferences: mockSharedPreferences,
    );

    container = ProviderContainer(
      overrides: [],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('commentControllerProvider initializes with TextEditingController', () {
    final controller = container.read(commentControllerProvider);
    expect(controller, isA<TextEditingController>());
  });

  test('commentsProvider fetches comments', () async {
    final poemId = '1';
    final comments = [
      {'username': 'user1', 'comment': 'Nice poem!'},
    ];

    when(mockSharedPreferences.getString('token')).thenReturn('fake_token');
    when(mockClient.get(
      Uri.parse('http://10.0.2.2:3000/api/comments/$poemId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(comments), 200));

    final result = await container.read(commentsProvider(poemId).future);

    expect(result, comments);
  });

  test('is true widget', () async {
    expect(true, isTrue);
  });
}
