import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readwenderlich/data/repository.dart';
import 'package:readwenderlich/ui/preferences/list_preferences.dart';
import 'package:readwenderlich/ui/preferences/list_preferences_screen.dart';
import 'package:readwenderlich/ui/list/paged_article_list_view.dart';

/// Integrates a list of articles with [ListPreferencesScreen].
class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  ListPreferences _listPreferences;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Articles',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {
                _pushListPreferencesScreen(context);
              },
            )
          ],
        ),
        body: PagedArticleListView(
          repository: Provider.of<Repository>(context),
          listPreferences: _listPreferences,
        ),
      );

  Future<void> _pushListPreferencesScreen(BuildContext context) async {
    final route = MaterialPageRoute<ListPreferences>(
      builder: (_) => ListPreferencesScreen(
        repository: Provider.of<Repository>(context),
        preferences: _listPreferences,
      ),
      fullscreenDialog: true,
    );
    final newPreferences = await Navigator.of(context).push(route);
    if (newPreferences != null) {
      setState(() {
        _listPreferences = newPreferences;
      });
    }
  }
}
