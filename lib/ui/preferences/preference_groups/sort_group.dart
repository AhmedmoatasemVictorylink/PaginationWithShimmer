

import 'package:flutter/material.dart';
import 'package:readwenderlich/ui/app_colors.dart';

/// Groups choice chips and assigns a label to the group.
class SortGroup extends StatelessWidget {
  const SortGroup({
    @required this.title,
    @required this.options,
    @required this.selectedOptionId,
    this.onOptionTap,
    Key key,
  })  : assert(title != null),
        assert(options != null),
        assert(selectedOptionId != null),
        super(key: key);

  final String title;
  final List<SortOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<SortOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sort),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            _OptionList(
              options: options,
              selectedOptionId: selectedOptionId,
              onOptionTap: onOptionTap,
            ),
          ],
        ),
      );
}

class _OptionList extends StatelessWidget {
  const _OptionList({
    @required this.selectedOptionId,
    @required this.onOptionTap,
    this.options,
    Key key,
  })  : assert(selectedOptionId != null),
        assert(onOptionTap != null),
        super(key: key);

  final List<SortOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<SortOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        children: [
          ...options.map(
            (option) {
              final isItemSelected = selectedOptionId == option.id;
              return ChoiceChip(
                label: Text(
                  option.name,
                  style: TextStyle(
                    color: isItemSelected ? Colors.white : AppColors.black,
                  ),
                ),
                onSelected:
                    onOptionTap != null ? (_) => onOptionTap(option) : null,
                selected: isItemSelected,
                backgroundColor: Colors.white,
                selectedColor: AppColors.green,
              );
            },
          ).toList(),
        ],
      );
}

class SortOption {
  SortOption({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
  final dynamic id;
  final String name;
}
