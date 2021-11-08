
import 'package:readwenderlich/entities/article_category.dart';
import 'package:readwenderlich/entities/article_platform.dart';

/// Puts and gets data from an in-memory storage (non-persistent).
class InMemoryStore {
  List<ArticlePlatform> _platformList;
  List<ArticleCategory> _categoryList;

  Future<void> insertPlatformList(List<ArticlePlatform> platformList) =>
      Future.microtask(() => _platformList = platformList);

  Future<void> insertCategoryList(List<ArticleCategory> categoryList) =>
      Future.microtask(() => _categoryList = categoryList);

  Future<List<ArticlePlatform>> getPlatformList() =>
      Future.microtask(() => _platformList);

  Future<List<ArticleCategory>> getCategoryList() =>
      Future.microtask(() => _categoryList);
}
