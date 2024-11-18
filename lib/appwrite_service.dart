import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "6739dd8a000d8f72094c";
  static const databaseId = "6739dde90024e674312c";
  static const collectionId = "6739decf0028060688a1";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getNotes() async {
    try {
      final result = await databases.listDocuments(
          databaseId: databaseId, collectionId: collectionId);
      return result.documents;
    } catch (e) {
      print('Error loading notes:$e');
      rethrow;
    }
  }

  Future<Document> addNote(
      String title, String description, String category, String date) async {
    try {
      final documentId = ID.unique();

      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        data: {
          'title': title,
          'description': description,
          'category': category,
          'date': date,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating note:$e');
      rethrow;
    }
  }

  Future<void> deleteNote(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting note:$e');
      rethrow;
    }
  }
}
