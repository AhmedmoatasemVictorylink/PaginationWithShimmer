

import 'package:flutter/material.dart';
import 'package:readwenderlich/ui/app_colors.dart';

/// Groups filter chips and assigns a label to the group.
class FilterGroup extends StatelessWidget {
  const FilterGroup({
    @required this.title,
    @required this.options,
    this.onClearAll,
    this.onOptionTap,
    Key key,
  })  : assert(title != null),
        assert(options != null),
        super(key: key);
  final String title;
  final List<FilterOption> options;
  final ValueChanged<FilterOption> onOptionTap;
  final VoidCallback onClearAll;

  bool get _hasSelectedItems => options
      .where(
        (option) => option.isSelected,
      )
      .isNotEmpty;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                if (onClearAll != null)
                  IconButton(
                    tooltip: 'Clear all',
                    color: AppColors.green,
                    icon: const Icon(
                      Icons.clear_all,
                    ),
                    onPressed: _hasSelectedItems ? onClearAll : null,
                  ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            _OptionList(
              options: options,
              onOptionTap: onOptionTap,
            ),
          ],
        ),
      );
}

class _OptionList extends StatelessWidget {
  const _OptionList({
    @required this.options,
    this.onOptionTap,
    Key key,
  })  : assert(options != null),
        super(key: key);
  final List<FilterOption> options;
  final ValueChanged<FilterOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        children: [
          ...options
              .map(
                (option) => FilterChip(
                  label: Text(
                    option.name,
                    style: TextStyle(
                      color: option.isSelected ? Colors.white : AppColors.black,
                    ),
                  ),
                  onSelected:
                      onOptionTap != null ? (_) => onOptionTap(option) : null,
                  selected: option.isSelected,
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.green,
                  checkmarkColor: Colors.white,
                ),
              )
              .toList(),
        ],
      );
}

class FilterOption {
  FilterOption({
    @required this.id,
    @required this.name,
    @required this.isSelected,
  })  : assert(id != null),
        assert(name != null),
        assert(isSelected != null);
  final dynamic id;
  final String name;
  final bool isSelected;
}
