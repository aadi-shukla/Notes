import 'package:get/get.dart';
import 'package:notes/network/model/note_model.dart';
import 'package:notes/services/hive_service.dart';

class NoteSearchController extends GetxController {
  final RxList<Note> searchResults = RxList<Note>();
  final RxString searchQuery = RxString('');
  final RxBool isSearching = RxBool(false);

  void search(String query) {
    try {
      searchQuery.value = query;
      if (query.isEmpty) {
        searchResults.clear();
        return;
      }

      isSearching.value = true;
      final results = HiveService.searchNotes(query);
      results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      searchResults.value = results;
    } catch (e) {
      print('Error searching notes: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  int getSearchResultCount() => searchResults.length;
}
