import 'package:decimal/decimal.dart';

import '../constants/conversions.dart';
import '../model/cuts.dart';
import '../model/fittings.dart';

List<Fit> makeFit(CutGroup cutGroup) {
  // Convert to mm
  Decimal maxLen = cutGroup.maxLen * inchToMm;
  Decimal sawWidth = cutGroup.sawWidth * inchToMm;

  final List<Fit> mmFits = [];

  // TODO sort cutGroup by length. Longest first.

  cutGroup.cuts.forEach((cut) {
    Decimal len = cut.len * inchToMm;
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

  return mmFits.map((fit) => fit / inchToMm).toList();
}
