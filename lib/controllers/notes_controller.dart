import 'package:get/get.dart';
import 'package:notes/app/helper/app_helper.dart';
import 'package:notes/network/model/note_model.dart';
import 'package:notes/services/hive_service.dart';

class NotesController extends GetxController {
  final RxList<Note> notes = RxList<Note>();
  final RxList<Note> pinnedNotes = RxList<Note>();
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadAllNotes();
  }

  void loadAllNotes() {
    try {
      isLoading.value = true;
      final allNotes = HiveService.getAllNotes();
      // Sort by updated date (newest first)
      allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notes.value = allNotes;
      _updatePinnedNotes();
    } catch (e) {
      print('Error loading notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNote({
    required String title,
    required String content,
    String? category,
    List<String>? tags,
    bool isMarkdown = false,
    String? color,
  }) async {
    try {
      isLoading.value = true;
      final now = DateTime.now();
      final note = Note(
        id: AppHelper.generateId(),
        title: title,
        content: content,
        category: category,
        tags: tags ?? [],
        createdAt: now,
        updatedAt: now,
        isMarkdown: isMarkdown,
        color: color,
      );

      await HiveService.addNote(note);
      loadAllNotes();

      Get.snackbar(
        'Success',
        'Note created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create note: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      isLoading.value = true;
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await HiveService.updateNote(updatedNote);
      loadAllNotes();

      Get.snackbar(
        'Success',
        'Note updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update note: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await HiveService.deleteNote(noteId);
      loadAllNotes();

      Get.snackbar(
        'Success',
        'Note deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete note: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> togglePin(Note note) async {
    try {
      final updatedNote = note.copyWith(isPinned: !note.isPinned);
      await HiveService.updateNote(updatedNote);
      loadAllNotes();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update note: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<Note> getNotesByCategory(String category) {
    return HiveService.getNotesByCategory(category);
  }

  List<Note> getNotesByTag(String tag) {
    return HiveService.getNotesByTag(tag);
  }

  void _updatePinnedNotes() {
    pinnedNotes.value = notes.where((note) => note.isPinned).toList();
  }

  int getTotalNotes() => notes.length;
  int getTotalWords() =>
      notes.fold(0, (sum, note) => sum + AppHelper.getWordCount(note.content));
  int getTotalCharacters() => notes.fold(
      0, (sum, note) => sum + AppHelper.getCharacterCount(note.content));
}
