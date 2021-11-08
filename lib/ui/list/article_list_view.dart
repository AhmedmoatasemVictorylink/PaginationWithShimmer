
import 'package:flutter/material.dart';
import 'package:readwenderlich/data/repository.dart';
import 'package:readwenderlich/entities/article.dart';
import 'package:readwenderlich/ui/exception_indicators/empty_list_indicator.dart';
import 'package:readwenderlich/ui/exception_indicators/error_indicator.dart';
import 'package:readwenderlich/ui/list/article_list_item.dart';
import 'package:readwenderlich/ui/preferences/list_preferences.dart';

/// Based on the received preferences, fetches and displays a non-paginated
/// list of articles.
class ArticleListView extends StatefulWidget {
  const ArticleListView({
    @required this.repository,
    this.listPreferences,
    Key key,
  })  : assert(repository != null),
        super(key: key);

  final Repository repository;
  final ListPreferences listPreferences;

  @override
  _ArticleListViewState createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  Repository get _repository => widget.repository;
  bool _isLoading = true;
  List<Article> _articles;
  dynamic _error;

  ListPreferences get _listPreferences => widget.listPreferences;

  @override
  void initState() {
    _fetchArticles();
    super.initState();
  }

  @override
  void didUpdateWidget(ArticleListView oldWidget) {
    // When preferences changes, the widget is rebuilt and we need to re-fetch
    // the articles.
    if (oldWidget.listPreferences != widget.listPreferences) {
      _fetchArticles();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _fetchArticles() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _error = null;
        _articles = null;
      });
    }

    try {
      final page = await _repository.getArticleListPage(
        filteredPlatformIds: _listPreferences?.filteredPlatformIds,
        filteredDifficulties: _listPreferences?.filteredDifficulties,
        filteredCategoryIds: _listPreferences?.filteredCategoryIds,
        sortMethod: _listPreferences?.sortMethod,
      );

      setState(() {
        _articles = page.itemList;
        _isLoading = false;
        _error = null;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) => _isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : _error != null
          ? ErrorIndicator(
              error: _error,
              onTryAgain: _fetchArticles,
            )
          : _articles.isEmpty
              ? EmptyListIndicator()
              : ListView.separated(
                  itemBuilder: (context, index) => ArticleListItem(
                    article: _articles[index],
                  ),
                  itemCount: _articles.length,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                );
}
