import 'package:flutter/material.dart';

import '../model/dimensions.dart';
import 'dropdown_formfield.dart';

final List<DimensionItem> lumberSizes = [
  DimensionItem.oneByTwo,
  DimensionItem.oneByThree,
  DimensionItem.oneByFour,
  DimensionItem.oneByFive,
  DimensionItem.oneBySix,
  DimensionItem.oneByEight,
  DimensionItem.oneByTen,
  DimensionItem.oneByTwelve,
  DimensionItem.twoByTwo,
  DimensionItem.twoByThree,
  DimensionItem.twoByFour,
  DimensionItem.twoBySix,
  DimensionItem.twoByEight,
  DimensionItem.twoByTen,
  DimensionItem.twoByTwelve,
  DimensionItem.fourByFour,
  DimensionItem.fourBySix,
  DimensionItem.fourByEight,
  DimensionItem.sixBySix,
  DimensionItem.eightByEight,
];

final dimensionDataSource = lumberSizes
    .map((item) => {
          "value": item,
          "display": item.display,
        })
    .toList();

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
      dataSource: dimensionDataSource,
      textField: "display",
      valueField: "value",
    );
  }
}
