import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:readwenderlich/data/stores/remote/json_structures/query_result.dart';
import 'package:readwenderlich/entities/article.dart';
import 'package:readwenderlich/entities/article_category.dart';
import 'package:readwenderlich/entities/article_difficulty.dart';
import 'package:readwenderlich/entities/article_platform.dart';
import 'package:readwenderlich/entities/list_page.dart';
import 'package:readwenderlich/entities/sort_method.dart';

/// Gets information from the raywenderlich.com API.
class RemoteStore {
  RemoteStore({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<List<ArticlePlatform>> getPlatformList() => dio.getEntityList(
        _platformsPath,
        (queryItem) => ArticlePlatform.fromQueryItem(queryItem),
      );

  Future<List<ArticleCategory>> getCategoryList() => dio.getEntityList(
        _categoriesPath,
        (queryItem) => ArticleCategory.fromQueryItem(queryItem),
      );

  Future<ListPage<Article>> getArticleListPage({
    int number,
    int size,
    List<int> filteredPlatformIds,
    List<int> filteredCategoryIds,
    List<ArticleDifficulty> filteredDifficulties,
    SortMethod sortMethod,
  }) {
    final filteredDifficultiesNames = filteredDifficulties
        ?.map((difficulty) => difficulty.queryParamValue)
        ?.toList();

    final sortMethodQueryParamValue =
        sortMethod == null ? null : '-${sortMethod.queryParamValue}';

    return dio.getQueryResult<Article, int>(
      _contentsPath,
      (queryItem) => Article.fromQueryItem(queryItem),
      metaDataParser: (json) => json['total_result_count'],
      queryParameters: {
        _contentTypeQueryParam: _articleQueryParamValue,
        _pageNumberQueryParam: number,
        _pageSizeQueryParam: size,
        _platformIdsQueryParam: _formatListToQueryValueArray(
          filteredPlatformIds,
        ),
        _categoryIdsQueryParam: _formatListToQueryValueArray(
          filteredCategoryIds,
        ),
        _difficultiesQueryParam: _formatListToQueryValueArray(
          filteredDifficultiesNames,
        ),
        _sortQueryParam: sortMethodQueryParamValue,
      },
    ).then(
      (responseBody) => ListPage<Article>(
        itemList: responseBody.items,
        grandTotalCount: responseBody.meta,
      ),
    );
  }

  static const _platformsPath = 'domains';
  static const _contentsPath = 'contents';
  static const _categoriesPath = 'categories';

  static const _contentTypeQueryParam = 'filter[content_types][]';
  static const _platformIdsQueryParam = 'filter[domain_ids]';
  static const _categoryIdsQueryParam = 'filter[category_ids]';
  static const _difficultiesQueryParam = 'filter[difficulties]';
  static const _sortQueryParam = 'sort';
  static const _pageNumberQueryParam = 'page[number]';
  static const _pageSizeQueryParam = 'page[size]';
  static const _articleQueryParamValue = 'article';

  static List<T> _formatListToQueryValueArray<T>(List<T> list) {
    final hasItems = list?.isEmpty != false;
    return hasItems ? null : list;
  }
}

extension on Dio {
  Future<List<DataType>> getEntityList<DataType>(
    String path,
    QueryItemParser queryItemParser, {
    Map<String, dynamic> queryParameters,
  }) =>
      getQueryResult<DataType, void>(
        path,
        queryItemParser,
        queryParameters: queryParameters,
      ).then(
        (value) => value.items,
      );

  Future<QueryResult<DataType, MetaDataType>>
      getQueryResult<DataType, MetaDataType>(
    String path,
    QueryItemParser queryItemParser, {
    Map<String, dynamic> queryParameters,
    JsonParser<MetaDataType> metaDataParser,
  }) =>
          get(
            path,
            queryParameters: queryParameters,
          )
              .then(
                (response) => json.decode(response.data),
              )
              .then(
                (responseBody) => QueryResult<DataType, MetaDataType>.fromJson(
                  responseBody,
                  queryItemParser,
                  metaDataParser: metaDataParser,
                ),
              )
              .catchError((error) {
            if (error is DioError && error.error is SocketException) {
              throw error.error;
            }

            throw error;
          });
}

extension on ArticleDifficulty {
  String get queryParamValue => this == ArticleDifficulty.beginner
      ? 'beginner'
      : this == ArticleDifficulty.intermediate
          ? 'intermediate'
          : 'advanced';
}

extension on SortMethod {
  String get queryParamValue =>
      this == SortMethod.releaseDate ? 'released_at' : 'popularity';
}
