import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p/models/poem_model.dart';

class UserPoemWidget extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final String poemId;

  const UserPoemWidget(
      {Key? key,
      required this.title,
      required this.content,
      required this.author,
      required this.poemId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
      decoration: BoxDecoration(
          color: Colors.blue[400], borderRadius: BorderRadius.circular(10)),
      child: TextButton(
        onPressed: () {
          print('clicked');
          print('Poem ID: $poemId');
          context.go(
            '/poem-detail',
            extra: Poem(
                title: title,
                content: content,
                author: author,
                id: poemId,
                genre: 'General'),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]!),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  author,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.favorite,
                      size: 40,
                    ),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
