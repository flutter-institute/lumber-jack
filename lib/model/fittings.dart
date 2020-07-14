import 'package:decimal/decimal.dart';

class Fit {
  final Decimal totalLen;
  final Decimal sawWidth;
  Decimal _leftovers;
  List<Decimal> cuts;

  Fit(this.totalLen, this.sawWidth) {
    _leftovers = totalLen;
    cuts = [];
  }

  void _calcLeftovers() {
    var cutSum = cuts.reduce((value, element) => value + element);
    var sawSum = sawWidth * Decimal.fromInt(cuts.length - 1);
    _leftovers = totalLen - cutSum - sawSum;
  }

  bool canFit(Decimal cutLen) {
    var buffer = cuts.isEmpty ? Decimal.zero : sawWidth;
    var remaining = _leftovers - buffer - cutLen;

    return remaining > Decimal.zero;
  }

  void addCut(Decimal cutLen) {
    cuts.add(cutLen);
    _calcLeftovers();
  }

  void addCuts(Iterable<Decimal> cutLens) {
    cuts.addAll(cutLens);
    _calcLeftovers();
  }

  Fit operator *(Decimal factor) => Fit(totalLen * factor, sawWidth * factor)
    ..addCuts(cuts.map((c) => c * factor));

  Fit operator /(Decimal factor) => Fit(totalLen / factor, sawWidth / factor)
    ..addCuts(cuts.map((c) => c / factor));
}
