
import 'package:readwenderlich/entities/article_difficulty.dart';
import 'package:readwenderlich/entities/sort_method.dart';

/// Wraps the filtering and sorting options for a list of articles.
class ListPreferences {
  ListPreferences({
    this.filteredPlatformIds,
    this.filteredCategoryIds,
    this.filteredDifficulties,
    this.sortMethod,
  });
  final List<int> filteredPlatformIds;
  final List<int> filteredCategoryIds;
  final List<ArticleDifficulty> filteredDifficulties;
  final SortMethod sortMethod;
}
