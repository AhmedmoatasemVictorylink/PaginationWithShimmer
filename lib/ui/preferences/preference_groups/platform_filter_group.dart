

import 'package:flutter/material.dart';
import 'package:readwenderlich/entities/article_platform.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/filter_group.dart';

/// Filter group for articles' platform options.
class PlatformFilterGroup extends StatelessWidget {
  const PlatformFilterGroup({
    @required this.platforms,
    @required this.selectedItemsIds,
    this.onOptionTap,
    this.onClearAll,
    Key key,
  }) : super(key: key);

  final ValueChanged<FilterOption> onOptionTap;
  final VoidCallback onClearAll;
  final List<ArticlePlatform> platforms;
  final List<int> selectedItemsIds;

  @override
  Widget build(BuildContext context) => FilterGroup(
        title: 'Choose platforms',
        onClearAll: onClearAll,
        onOptionTap: onOptionTap,
        options: platforms
            .map(
              (platform) => FilterOption(
                id: platform.id,
                name: platform.name,
                isSelected: selectedItemsIds.contains(platform.id),
              ),
            )
            .toList(),
      );
}
