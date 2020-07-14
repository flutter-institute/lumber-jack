import 'package:decimal/decimal.dart';

import 'dimensions.dart';

class CutGroup {
  DimensionItem dimensions;
  Decimal maxLen = Decimal.fromInt(96);
  Decimal sawWidth = Decimal.parse("0.25");
  List<CutDesc> cuts = [];
}

class CutDesc {
  Decimal len;
  int count;

  CutDesc([Decimal len, this.count = 0]) {
    this.len = len ?? Decimal.zero;
  }
}
