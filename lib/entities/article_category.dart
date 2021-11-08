
import 'package:flutter/foundation.dart';
import 'package:readwenderlich/data/stores/remote/json_structures/query_item.dart';

/// An article's category, such as 'Tools & Libraries' or 'Testing'.
class ArticleCategory {
  ArticleCategory({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  factory ArticleCategory.fromQueryItem(QueryItem queryItem) => ArticleCategory(
        id: queryItem.id,
        name: queryItem.attributes['name'],
      );

  final int id;
  final String name;
}
