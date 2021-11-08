

import 'package:flutter/material.dart';
import 'package:readwenderlich/entities/article_difficulty.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/filter_group.dart';

/// Filter group for articles' difficulty options.
class DifficultyFilterGroup extends StatelessWidget {
  const DifficultyFilterGroup({
    @required this.selectedItems,
    this.onOptionTap,
    this.onClearAll,
    Key key,
  }) : super(key: key);

  final ValueChanged<FilterOption> onOptionTap;
  final VoidCallback onClearAll;
  List<ArticleDifficulty> get _difficultyList => ArticleDifficulty.values;
  final List<ArticleDifficulty> selectedItems;

  @override
  Widget build(BuildContext context) => FilterGroup(
        title: 'Choose difficulties',
        onClearAll: onClearAll,
        onOptionTap: onOptionTap,
        options: _difficultyList
            .map(
              (difficulty) => FilterOption(
                id: difficulty,
                name: difficulty == ArticleDifficulty.beginner
                    ? 'Beginner'
                    : difficulty == ArticleDifficulty.intermediate
                        ? 'Intermediate'
                        : 'Advanced',
                isSelected: selectedItems.contains(
                  difficulty,
                ),
              ),
            )
            .toList(),
      );
}
