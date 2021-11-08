

import 'package:flutter/material.dart';
import 'package:readwenderlich/entities/article_category.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/filter_group.dart';

/// Filter group for articles' category options.
class CategoryFilterGroup extends StatelessWidget {
  const CategoryFilterGroup({
    @required this.categories,
    @required this.selectedItemsIds,
    this.onOptionTap,
    this.onClearAll,
    Key key,
  }) : super(key: key);

  final ValueChanged<FilterOption> onOptionTap;
  final VoidCallback onClearAll;
  final List<ArticleCategory> categories;
  final List<int> selectedItemsIds;

  @override
  Widget build(BuildContext context) => FilterGroup(
        title: 'Choose categories',
        onClearAll: onClearAll,
        onOptionTap: onOptionTap,
        options: categories
            .map(
              (category) => FilterOption(
                id: category.id,
                name: category.name,
                isSelected: selectedItemsIds.contains(category.id),
              ),
            )
            .toList(),
      );
}
