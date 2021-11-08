import 'package:flutter/foundation.dart';

/// Item-level structure returned by raywenderlich.com API endpoints.
class QueryItem {
  const QueryItem({
    @required this.id,
    @required this.attributes,
  })  : assert(id != null),
        assert(attributes != null);

  factory QueryItem.fromJson(Map<String, dynamic> json) => QueryItem(
        id: int.parse(json['id']),
        attributes: json['attributes'],
      );
  final int id;
  final Map<String, dynamic> attributes;
}
