import 'package:appwrite/models.dart';

class Note {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
  });

  factory Note.fromDocument(Document doc) {
    return Note(
        id: doc.$id,
        title: doc.data['title'],
        description: doc.data['description'],
        category: doc.data['category'],
        date: doc.data['date']);
  }
}
