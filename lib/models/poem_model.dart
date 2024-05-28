class Poem {
  final String id;
  final String title;
  final String author;
  final String content;
  final String genre;

  Poem({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.genre,
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      genre: json['genre'],
    );
  }
}
