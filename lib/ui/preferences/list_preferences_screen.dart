

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:readwenderlich/data/repository.dart';
import 'package:readwenderlich/entities/article_category.dart';
import 'package:readwenderlich/entities/article_difficulty.dart';
import 'package:readwenderlich/entities/article_platform.dart';
import 'package:readwenderlich/entities/sort_method.dart';
import 'package:readwenderlich/ui/exception_indicators/error_indicator.dart';
import 'package:readwenderlich/ui/preferences/list_preferences.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/category_filter_group.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/difficulty_filter_group.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/platform_filter_group.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/sort_method_group.dart';

/// Filtering and sorting options selection screen.
class ListPreferencesScreen extends StatefulWidget {
  const ListPreferencesScreen({
    @required this.repository,
    this.preferences,
    Key key,
  })  : assert(repository != null),
        super(key: key);

  final Repository repository;
  final ListPreferences preferences;

  @override
  _ListPreferencesScreenState createState() => _ListPreferencesScreenState();
}

class _ListPreferencesScreenState extends State<ListPreferencesScreen> {
  Repository get _repository => widget.repository;
  bool _isLoading = true;
  List<ArticlePlatform> _platforms;
  List<ArticleCategory> _categories;
  dynamic _error;

  List<int> _selectedPlatformIds = [];
  List<int> _selectedCategoryIds = [];
  List<ArticleDifficulty> _selectedDifficulties = [];
  SortMethod _selectedSortMethod = SortMethod.releaseDate;

  ListPreferences get _previousPreferences => widget.preferences;

  List<int> get _previousPlatformIds =>
      _previousPreferences?.filteredPlatformIds ?? [];

  List<int> get _previousCategoryIds =>
      _previousPreferences?.filteredCategoryIds ?? [];

  List<ArticleDifficulty> get _previousDifficulties =>
      _previousPreferences?.filteredDifficulties ?? [];

  SortMethod get _previousSortMethod =>
      _previousPreferences?.sortMethod ?? SortMethod.releaseDate;

  bool get _hasChangedPlatforms => !listEquals(
        _previousPlatformIds,
        _selectedPlatformIds,
      );

  bool get _hasChangedCategories => !listEquals(
        _previousCategoryIds,
        _selectedCategoryIds,
      );

  bool get _hasChangedDifficulties => !listEquals(
        _previousDifficulties,
        _selectedDifficulties,
      );

  bool get _hasChangedSortMethod => _previousSortMethod != _selectedSortMethod;

  bool get _hasChangedPreferences =>
      _hasChangedPlatforms ||
      _hasChangedCategories ||
      _hasChangedDifficulties ||
      _hasChangedSortMethod;

  @override
  void initState() {
    _fetchFilterOptions();

    final previousPreferences = widget.preferences;
    if (previousPreferences != null) {
      _selectedCategoryIds = List.of(previousPreferences.filteredCategoryIds);
      _selectedPlatformIds = List.of(previousPreferences.filteredPlatformIds);
      _selectedDifficulties = List.of(previousPreferences.filteredDifficulties);
      _selectedSortMethod = previousPreferences.sortMethod;
    }

    super.initState();
  }

  Future<void> _fetchFilterOptions() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _error = null;
        _platforms = null;
        _categories = null;
      });
    }

    try {
      final results = await Future.wait(
        [
          _repository.getPlatformList(),
          _repository.getCategoryList(),
        ],
      );
      setState(() {
        _platforms = results[0];
        _categories = results[1];
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'List Preferences',
          ),
          actions: _hasChangedPreferences
              ? [
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      _sendResultsBack(context);
                    },
                  )
                ]
              : null,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error != null
                ? ErrorIndicator(
                    error: _error,
                    onTryAgain: _fetchFilterOptions,
                  )
                : ListView(
                    children: [
                      SortMethodGroup(
                        selectedItem: _selectedSortMethod,
                        onOptionTap: (option) => setState(
                          () => _selectedSortMethod = option.id,
                        ),
                      ),
                      const Divider(),
                      PlatformFilterGroup(
                        platforms: _platforms,
                        selectedItemsIds: _selectedPlatformIds,
                        onClearAll: () => setState(_selectedPlatformIds.clear),
                        onOptionTap: (option) => setState(
                          () => _selectedPlatformIds.toggleItem(
                            option.id,
                          ),
                        ),
                      ),
                      const Divider(),
                      DifficultyFilterGroup(
                        onClearAll: () => setState(_selectedDifficulties.clear),
                        onOptionTap: (option) => setState(
                          () => _selectedDifficulties.toggleItem(
                            option.id,
                          ),
                        ),
                        selectedItems: _selectedDifficulties,
                      ),
                      const Divider(),
                      CategoryFilterGroup(
                        categories: _categories,
                        selectedItemsIds: _selectedCategoryIds,
                        onClearAll: () => setState(_selectedCategoryIds.clear),
                        onOptionTap: (option) => setState(
                          () => _selectedCategoryIds.toggleItem(
                            option.id,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
      );

  void _sendResultsBack(BuildContext context) {
    Navigator.of(context).pop(
      ListPreferences(
        filteredCategoryIds: _selectedCategoryIds,
        filteredDifficulties: _selectedDifficulties,
        filteredPlatformIds: _selectedPlatformIds,
        sortMethod: _selectedSortMethod,
      ),
    );
  }
}

extension _Toggle<T> on List<T> {
  void toggleItem(T item) => contains(item) ? remove(item) : add(item);
}
