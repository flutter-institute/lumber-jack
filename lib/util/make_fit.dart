import 'package:decimal/decimal.dart';

import '../model/cuts.dart';
import '../model/fittings.dart';

final toMM = Decimal.parse("25.4");

List<Fit> makeFit(CutGroup cutGroup) {
  // Convert to mm
  Decimal maxLen = cutGroup.maxLen * toMM;
  Decimal sawWidth = cutGroup.sawWidth * toMM;

  final List<Fit> mmFits = [];

  // TODO sort cutGroup by length. Longest first.

  cutGroup.cuts.forEach((cut) {
    Decimal len = cut.len * toMM;
    for (var i = 0; i < cut.count; i++) {
      bool newFit = true;
      for (var f = 0; f < mmFits.length; f++) {
        var fit = mmFits[f];
        if (fit.canFit(len)) {
          fit.addCut(len);
          newFit = false;
          break;
        }
      }

      if (newFit) {
        var f = Fit(maxLen, sawWidth);
        f.addCut(len);

        mmFits.add(f);
      }
    }
  });

  return mmFits.map((fit) => fit / toMM).toList();
}
