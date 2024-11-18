import 'package:appwrite_noteapp/appwrite_service.dart';
import 'package:appwrite_noteapp/note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late AppwriteService _appwriteService;
  late List<Note> _notes;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteService.getNotes();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks:$e');
    }
  }

  Future<void> _addNote() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final category = categoryController.text;
    final date = dateController.text;

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty) {
      try {
        await _appwriteService.addNote(title, description, category, date);
        titleController.clear();
        descriptionController.clear();
        categoryController.clear();
        dateController.clear();
        _loadNotes();
      } catch (e) {
        print('Error adding task:$e');
      }
    }
  }

  Future<void> _deleteNote(String taskId) async {
    try {
      await _appwriteService.deleteNote(taskId);
      _loadNotes();
    } catch (e) {
      print('Error deleting task:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App Example"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            width: 250,
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'title'),
            ),
          ),
          SizedBox(
            height: 40,
            width: 250,
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'description'),
            ),
          ),
          SizedBox(
            height: 40,
            width: 250,
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'category'),
            ),
          ),
          SizedBox(
            height: 40,
            width: 250,
            child: TextField(
              controller: dateController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'date'),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _addNote, child: Text("Add Notes")),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final notes = _notes[index];
                    return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 247, 193, 211)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notes.title),
                                Text(notes.description),
                                Text(notes.category),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(notes.date),
                                      Spacer(),
                                      GestureDetector(
                                          onTap: () => _deleteNote(notes.id),
                                          child: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ]),
                        ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
