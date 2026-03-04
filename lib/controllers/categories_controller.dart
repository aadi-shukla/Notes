import 'package:get/get.dart';
import 'package:notes/app/helper/app_helper.dart';
import 'package:notes/network/model/category_model.dart';
import 'package:notes/services/hive_service.dart';

class CategoriesController extends GetxController {
  final RxList<Category> categories = RxList<Category>();
  final RxBool isLoading = RxBool(false);

  final List<String> defaultIcons = [
    '📚',
    '💼',
    '🎓',
    '🏃',
    '🍎',
    '🎵',
    '🎨',
    '✈️',
    '🏠',
    '❤️',
  ];

  final List<String> defaultColors = [
    '#FF6B6B',
    '#4ECDC4',
    '#45B7D1',
    '#FFA07A',
    '#98D8C8',
    '#F7DC6F',
    '#BB8FCE',
    '#85C1E2',
  ];

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    try {
      isLoading.value = true;
      categories.value = HiveService.getAllCategories();
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory({
    required String name,
    String? description,
    String? icon,
    String? color,
  }) async {
    try {
      isLoading.value = true;
      final category = Category(
        id: AppHelper.generateId(),
        name: name,
        description: description,
        icon: icon,
        color: color,
        createdAt: DateTime.now(),
      );

      await HiveService.addCategory(category);
      loadCategories();

      Get.snackbar(
        'Success',
        'Category created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create category: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      isLoading.value = true;
      await HiveService.updateCategory(category);
      loadCategories();

      Get.snackbar(
        'Success',
        'Category updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update category: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;
      await HiveService.deleteCategory(categoryId);
      loadCategories();

      Get.snackbar(
        'Success',
        'Category deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int getTotalCategories() => categories.length;
}
