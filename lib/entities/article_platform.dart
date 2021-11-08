
import 'package:flutter/foundation.dart';
import 'package:readwenderlich/data/stores/remote/json_structures/query_item.dart';

/// An article's platform, such as 'iOS', 'Android' or 'Flutter'.
class ArticlePlatform {
  ArticlePlatform({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  factory ArticlePlatform.fromQueryItem(QueryItem queryItem) => ArticlePlatform(
        id: queryItem.id,
        name: queryItem.attributes['name'],
      );

  final int id;
  final String name;
}
