
import 'package:flutter/material.dart';
import 'package:readwenderlich/data/stores/in_memory_store.dart';
import 'package:readwenderlich/data/stores/remote/remote_store.dart';
import 'package:readwenderlich/entities/article.dart';
import 'package:readwenderlich/entities/article_category.dart';
import 'package:readwenderlich/entities/article_difficulty.dart';
import 'package:readwenderlich/entities/article_platform.dart';
import 'package:readwenderlich/entities/list_page.dart';
import 'package:readwenderlich/entities/sort_method.dart';

/// Gets data from both [RemoteStore] and [InMemoryStore].
class Repository {
  const Repository({
    @required this.remoteStore,
    @required this.inMemoryStore,
  })  : assert(remoteStore != null),
        assert(inMemoryStore != null);
  final RemoteStore remoteStore;
  final InMemoryStore inMemoryStore;

  Future<ListPage<Article>> getArticleListPage({
    int number,
    int size,
    List<int> filteredPlatformIds,
    List<int> filteredCategoryIds,
    List<ArticleDifficulty> filteredDifficulties,
    SortMethod sortMethod,
  }) =>
      remoteStore.getArticleListPage(
        number: number,
        size: size,
        filteredPlatformIds: filteredPlatformIds,
        filteredCategoryIds: filteredCategoryIds,
        filteredDifficulties: filteredDifficulties,
        sortMethod: sortMethod,
      );

  Future<List<ArticleCategory>> getCategoryList() =>
      inMemoryStore.getCategoryList().then(
            (inMemoryCategoryList) =>
                inMemoryCategoryList ?? _getCategoryListFromRemoteStore(),
          );

  Future<List<ArticleCategory>> _getCategoryListFromRemoteStore() =>
      remoteStore.getCategoryList().then(
            (categoryList) => inMemoryStore
                .insertCategoryList(
                  categoryList,
                )
                .then(
                  (_) => categoryList,
                ),
          );

  Future<List<ArticlePlatform>> getPlatformList() =>
      inMemoryStore.getPlatformList().then(
            (inMemoryPlatformList) =>
                inMemoryPlatformList ?? _getPlatformListFromRemoteStore(),
          );

  Future<List<ArticlePlatform>> _getPlatformListFromRemoteStore() =>
      remoteStore.getPlatformList().then(
            (platformList) => inMemoryStore
                .insertPlatformList(
                  platformList,
                )
                .then(
                  (_) => platformList,
                ),
          );
}
