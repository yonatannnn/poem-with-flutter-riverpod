import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/poems_provider.dart';
import '../screens/poem_detail.dart';
import '../widgets/poems_list.dart';

class poemsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PoemsScreen(),
    );
  }
}
