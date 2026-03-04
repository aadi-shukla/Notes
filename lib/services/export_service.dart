import 'dart:convert';
import 'dart:io';
import 'package:notes/network/model/note_model.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static Future<String> exportNotesToJson(List<Note> notes) async {
    final Map<String, dynamic> exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'totalNotes': notes.length,
      'notes': notes.map((note) => note.toJson()).toList(),
    };

    return jsonEncode(exportData);
  }

  static Future<File> saveJsonFile(String jsonData) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'notes_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(jsonData);
    return file;
  }

  static Future<String> exportSingleNoteToJson(Note note) async {
    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'note': note.toJson(),
    };

    return jsonEncode(exportData);
  }

  static Future<List<Note>> importNotesFromJson(String jsonData) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData);
      final List<dynamic> notesJson = data['notes'] ?? [];

      return notesJson
          .map((noteJson) => Note.fromJson(noteJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error importing notes: $e');
      return [];
    }
  }
}
