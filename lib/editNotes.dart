import 'package:flutter/material.dart';
import 'package:uas_ambw/boxes.dart';
import 'package:uas_ambw/note.dart';

class EditNotes extends StatefulWidget {
  final int index;
  const EditNotes({super.key, required this.index});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: EditNotesPage(
        index: widget.index,
      ),
    );
  }
}

class EditNotesPage extends StatefulWidget {
  final int index;
  const EditNotesPage({super.key, required this.index});

  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  late TextEditingController _titleController;
  late TextEditingController _isiController;
  late DateTime _created;

  @override
  void initState() {
    super.initState();
    Note note = notesBox.getAt(widget.index)!;
    _created = note.created;
    _titleController = TextEditingController(text: note.judul);
    _isiController = TextEditingController(text: note.isi);
  }

  @override
  void dispose() {
    // Dispose the TextEditingController instances when they are no longer needed
    _titleController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter your title",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Isi",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _isiController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Enter your notes",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var newNote = Note(
                      judul: _titleController.text,
                      isi: _isiController.text,
                      created: _created,
                      edited: DateTime.now(),
                    );
                    await notesBox.putAt(widget.index, newNote);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save Note",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
