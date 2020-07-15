import 'package:decimal/decimal.dart';

import '../constants/conversions.dart';
import '../model/cuts.dart';
import '../model/fittings.dart';

List<Fit> makeFit(CutGroup cutGroup) {
  // Convert to mm
  Decimal maxLen = cutGroup.maxLen * inchToMm;
  Decimal sawWidth = cutGroup.sawWidth * inchToMm;

  final List<Fit> mmFits = [];

  // Defensive copy
  final cuts = List<CutDesc>.from(cutGroup.cuts);
  cuts.sort((c1, c2) => c1.len.compareTo(c2.len));

  cuts.forEach((cut) {
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
