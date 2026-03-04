import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/network/model/alarm_model.dart';
import 'package:notes/network/model/category_model.dart';
import 'package:notes/network/model/note_model.dart';
import 'package:notes/network/model/tag_model.dart';

class HiveService {
  static const String notesBoxName = 'notes';
  static const String categoriesBoxName = 'categories';
  static const String tagsBoxName = 'tags';
  static const String alarmsBoxName = 'alarms';
  static const String settingsBoxName = 'settings';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(AlarmAdapter());

    // Open boxes
    await Hive.openBox<Note>(notesBoxName);
    await Hive.openBox<Category>(categoriesBoxName);
    await Hive.openBox<Tag>(tagsBoxName);
    await Hive.openBox<Alarm>(alarmsBoxName);
    await Hive.openBox(settingsBoxName);
  }

  // Note Operations
  static Future<void> addNote(Note note) async {
    final box = Hive.box<Note>(notesBoxName);
    await box.put(note.id, note);
  }

  static Future<void> updateNote(Note note) async {
    final box = Hive.box<Note>(notesBoxName);
    await box.put(note.id, note);
  }

  static Future<void> deleteNote(String noteId) async {
    final box = Hive.box<Note>(notesBoxName);
    await box.delete(noteId);
  }

  static Note? getNote(String noteId) {
    final box = Hive.box<Note>(notesBoxName);
    return box.get(noteId);
  }

  static List<Note> getAllNotes() {
    final box = Hive.box<Note>(notesBoxName);
    return box.values.toList();
  }

  static List<Note> getNotesByCategory(String category) {
    final box = Hive.box<Note>(notesBoxName);
    return box.values.where((note) => note.category == category).toList();
  }

  static List<Note> getNotesByTag(String tag) {
    final box = Hive.box<Note>(notesBoxName);
    return box.values.where((note) => note.tags.contains(tag)).toList();
  }

  static List<Note> searchNotes(String query) {
    final box = Hive.box<Note>(notesBoxName);
    final lowercaseQuery = query.toLowerCase();
    return box.values
        .where((note) =>
            note.title.toLowerCase().contains(lowercaseQuery) ||
            note.content.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Category Operations
  static Future<void> addCategory(Category category) async {
    final box = Hive.box<Category>(categoriesBoxName);
    await box.put(category.id, category);
  }

  static Future<void> updateCategory(Category category) async {
    final box = Hive.box<Category>(categoriesBoxName);
    await box.put(category.id, category);
  }

  static Future<void> deleteCategory(String categoryId) async {
    final box = Hive.box<Category>(categoriesBoxName);
    await box.delete(categoryId);
  }

  static List<Category> getAllCategories() {
    final box = Hive.box<Category>(categoriesBoxName);
    return box.values.toList();
  }

  // Tag Operations
  static Future<void> addTag(Tag tag) async {
    final box = Hive.box<Tag>(tagsBoxName);
    await box.put(tag.id, tag);
  }

  static Future<void> updateTag(Tag tag) async {
    final box = Hive.box<Tag>(tagsBoxName);
    await box.put(tag.id, tag);
  }

  static Future<void> deleteTag(String tagId) async {
    final box = Hive.box<Tag>(tagsBoxName);
    await box.delete(tagId);
  }

  static List<Tag> getAllTags() {
    final box = Hive.box<Tag>(tagsBoxName);
    return box.values.toList();
  }

  // Alarm Operations
  static Future<void> addAlarm(Alarm alarm) async {
    final box = Hive.box<Alarm>(alarmsBoxName);
    await box.put(alarm.id, alarm);
  }

  static Future<void> updateAlarm(Alarm alarm) async {
    final box = Hive.box<Alarm>(alarmsBoxName);
    await box.put(alarm.id, alarm);
  }

  static Future<void> deleteAlarm(String alarmId) async {
    final box = Hive.box<Alarm>(alarmsBoxName);
    await box.delete(alarmId);
  }

  static List<Alarm> getAlarmsByNoteId(String noteId) {
    final box = Hive.box<Alarm>(alarmsBoxName);
    return box.values.where((alarm) => alarm.noteId == noteId).toList();
  }

  static List<Alarm> getActiveAlarms() {
    final box = Hive.box<Alarm>(alarmsBoxName);
    return box.values.where((alarm) => alarm.isActive).toList();
  }

  // Settings Operations
  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBoxName);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> clearAllData() async {
    await Hive.box<Note>(notesBoxName).clear();
    await Hive.box<Category>(categoriesBoxName).clear();
    await Hive.box<Tag>(tagsBoxName).clear();
    await Hive.box<Alarm>(alarmsBoxName).clear();
  }
}
