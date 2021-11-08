import 'package:flutter/foundation.dart';
import 'package:readwenderlich/data/stores/remote/json_structures/query_item.dart';

typedef JsonParser<T> = T Function(Map<String, dynamic> json);
typedef QueryItemParser<T> = T Function(
  QueryItem queryItem,
);

/// Root-level structure returned by raywenderlich.com API endpoints.
class QueryResult<DataType, MetaType> {
  const QueryResult({
    @required this.items,
    this.meta,
  }) : assert(items != null);

  factory QueryResult.fromJson(
    Map<String, dynamic> json,
    QueryItemParser<DataType> dataParser, {
    JsonParser<MetaType> metaDataParser,
  }) =>
      QueryResult<DataType, MetaType>(
        items: _parseDataFromJson(
          json,
          dataParser,
        ),
        meta: _parseMetaDataFromJson(
          json,
          metaDataParser,
        ),
      );

  final List<DataType> items;
  final MetaType meta;

  static List<DataType> _parseDataFromJson<DataType>(
    Map<String, dynamic> json,
    QueryItemParser<DataType> queryItemParser,
  ) =>
      _parseQueryItemListFromJson(
        json,
      )
          .map(
            queryItemParser,
          )
          .toList();

  static List<QueryItem> _parseQueryItemListFromJson(
    Map<String, dynamic> json,
  ) {
    final List<dynamic> dataJsonArray = json['data'];
    return dataJsonArray
        .cast()
        .map(
          (json) => QueryItem.fromJson(
            json,
          ),
        )
        .toList();
  }

  static MetaType _parseMetaDataFromJson<MetaType>(
    Map<String, dynamic> json,
    JsonParser<MetaType> parser,
  ) {
    final hasMetaParser = parser != null;
    return hasMetaParser
        ? parser(
            json['meta'],
          )
        : null;
  }
}
