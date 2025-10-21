import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/home screen/data/model/category_model.dart';
import 'package:interview/features/home screen/data/service/category_service.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<List<Category>>>(
  (ref) => CategoryController(ref.read(categoryServiceProvider)),
);

class CategoryController extends StateNotifier<AsyncValue<List<Category>>> {
  CategoryController(this._service)
      : super(const AsyncValue<List<Category>>.loading()) {
    loadCategories();
  }

  final CategoryService _service;

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.fetchCategories();
      state = AsyncValue.data(response.categories);
    } on CategoryException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
