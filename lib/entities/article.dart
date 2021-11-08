
import 'package:flutter/foundation.dart';
import 'package:readwenderlich/data/stores/remote/json_structures/query_item.dart';

class Article {
  const Article({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.releaseDate,
    @required this.duration,
    @required this.uri,
    this.artworkUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(description != null),
        assert(releaseDate != null),
        assert(uri != null),
        assert(duration != null);

  factory Article.fromQueryItem(QueryItem queryItem) {
    final releaseDateString = queryItem.attributes['released_at'];
    final releaseDate = DateTime.parse(
      releaseDateString,
    );

    return Article(
      id: queryItem.id,
      name: queryItem.attributes['name'],
      description: queryItem.attributes['description'],
      releaseDate: releaseDate,
      duration: queryItem.attributes['duration'],
      artworkUrl: queryItem.attributes['card_artwork_url'],
      uri: queryItem.attributes['uri'],
    );
  }

  final int id;
  final String name;
  final String description;
  final DateTime releaseDate;
  final int duration;
  final String artworkUrl;
  final String uri;
}
