import 'package:flutter/material.dart';

import 'dropdown_formfield.dart';

final _mmtoin = {
  19: 1,
  38: 2,
  64: 3,
  89: 4,
  114: 5,
  140: 6,
  184: 8,
  191: 8, // Because 8x8's are 7.5" instead of 7.25"
  235: 10,
  286: 12,
};

class DimensionItem {
  final int width;
  final int height;

  const DimensionItem(this.width, this.height);

  String get display {
    // TODO localize for which comes first
    return "${_mmtoin[width]}x${_mmtoin[height]} in (${width}x$height mm)";
  }

  @override
  String toString() {
    return "Dimensions($display)";
  }
}

final List<DimensionItem> lumberSizes = [
  DimensionItem(19, 38),
  DimensionItem(19, 64),
  DimensionItem(19, 89),
  DimensionItem(19, 114),
  DimensionItem(19, 140),
  DimensionItem(19, 184),
  DimensionItem(19, 235),
  DimensionItem(19, 286),
  DimensionItem(38, 38),
  DimensionItem(38, 64),
  DimensionItem(38, 89),
  DimensionItem(38, 140),
  DimensionItem(38, 184),
  DimensionItem(38, 235),
  DimensionItem(38, 286),
  DimensionItem(89, 89),
  DimensionItem(89, 140),
  DimensionItem(89, 184),
  DimensionItem(140, 140),
  DimensionItem(191, 191),
];

class DimensionSelector extends StatelessWidget {
  final DimensionItem value;
  final void Function(DimensionItem) onChanged;

  const DimensionSelector({
    Key key,
    this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropDownFormField<DimensionItem>(
      titleText: "Dimensions",
      hintText: "Select Dimensions",
      value: value,
      onSaved: onChanged,
      onChanged: onChanged,
      dataSource: lumberSizes
          .map((item) => {
                "value": item,
                "display": item.display,
              })
          .toList(),
      textField: "display",
      valueField: "value",
    );
  }
}
