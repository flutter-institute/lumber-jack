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
    return "$inches ($mm)";
  }

  String get inches {
    return "${_mmtoin[width]}x${_mmtoin[height]}\"";
  }

  String get mm {
    return "${width}x$height mm";
  }

  @override
  String toString() {
    return "Dimensions($display)";
  }

  static const oneByTwo = DimensionItem(19, 38);
  static const oneByThree = DimensionItem(19, 64);
  static const oneByFour = DimensionItem(19, 89);
  static const oneByFive = DimensionItem(19, 114);
  static const oneBySix = DimensionItem(19, 140);
  static const oneByEight = DimensionItem(19, 184);
  static const oneByTen = DimensionItem(19, 235);
  static const oneByTwelve = DimensionItem(19, 286);
  static const twoByTwo = DimensionItem(38, 38);
  static const twoByThree = DimensionItem(38, 64);
  static const twoByFour = DimensionItem(38, 89);
  static const twoBySix = DimensionItem(38, 140);
  static const twoByEight = DimensionItem(38, 184);
  static const twoByTen = DimensionItem(38, 235);
  static const twoByTwelve = DimensionItem(38, 286);
  static const fourByFour = DimensionItem(89, 89);
  static const fourBySix = DimensionItem(89, 140);
  static const fourByEight = DimensionItem(89, 184);
  static const sixBySix = DimensionItem(140, 140);
  static const eightByEight = DimensionItem(191, 191);
}
