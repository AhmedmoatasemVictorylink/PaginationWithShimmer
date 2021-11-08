

import 'package:flutter/material.dart';
import 'package:readwenderlich/entities/sort_method.dart';
import 'package:readwenderlich/ui/preferences/preference_groups/sort_group.dart';

/// Sort group for articles' sort options.
class SortMethodGroup extends StatelessWidget {
  const SortMethodGroup({
    @required this.selectedItem,
    this.onOptionTap,
    Key key,
  }) : super(key: key);

  final ValueChanged<SortOption> onOptionTap;
  final SortMethod selectedItem;
  @override
  Widget build(BuildContext context) => SortGroup(
        title: 'Sort by',
        options: SortMethod.values
            .map(
              (sortMethod) => SortOption(
                id: sortMethod,
                name: sortMethod == SortMethod.releaseDate
                    ? 'Newest'
                    : 'Most Popular',
              ),
            )
            .toList(),
        selectedOptionId: selectedItem,
        onOptionTap: onOptionTap,
      );
}
