import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wood/model/cuts.dart';
import 'package:wood/model/dimensions.dart';
import 'package:wood/model/fittings.dart';

import 'package:wood/util/make_fit.dart';

void main() {
  test('handles converstion factors', () {
    final first = Fit(Decimal.fromInt(10), Decimal.fromInt(1))
      ..addCuts([Decimal.one, Decimal.fromInt(8)]);

    final doubled = first * Decimal.fromInt(2);
    expect(doubled.totalLen.toInt(), equals(20));
    expect(doubled.sawWidth.toInt(), equals(2));
    expect(doubled.cuts, hasLength(2));
    expect(doubled.cuts[0].toInt(), equals(2));
    expect(doubled.cuts[1].toInt(), equals(16));

    final halfed = first / Decimal.fromInt(2);
    expect(halfed.totalLen.toInt(), equals(5));
    expect(halfed.sawWidth, equals(Decimal.parse("0.5")));
    expect(halfed.cuts, hasLength(2));
    expect(halfed.cuts[0], equals(Decimal.parse("0.5")));
    expect(halfed.cuts[1].toInt(), equals(4));
  });

  test('Properly handles the saw width', () {
    final d1 = Decimal.fromInt(48);

    final cutGroup = CutGroup()
      ..maxLen = Decimal.fromInt(96)
      ..sawWidth = Decimal.parse("0.25")
      ..dimensions = DimensionItem.twoByFour
      ..cuts = [
        CutDesc(d1, 2),
      ];

    final fit = makeFit(cutGroup);

    expect(fit, hasLength(2));
    expect(fit[0].cuts, hasLength(1));
    expect(fit[0].cuts, contains(d1));
    expect(fit[1].cuts, hasLength(1));
    expect(fit[1].cuts, contains(d1));
  });

  test('Properly groups cuts', () {
    final d1 = Decimal.fromInt(48);
    final d2 = Decimal.fromInt(24);
    final d3 = Decimal.fromInt(23);

    final cutGroup = CutGroup()
      ..maxLen = Decimal.fromInt(96)
      ..sawWidth = Decimal.parse("0.25")
      ..dimensions = DimensionItem.twoByFour
      ..cuts = [
        CutDesc(d1, 2),
        CutDesc(d3, 3),
        CutDesc(d2, 3),
      ];

    final fit = makeFit(cutGroup);

    expect(fit, hasLength(3));
    expect(fit[0].cuts, hasLength(3));
    expect(fit[0].cuts, containsAll([d1, d2, d3]));
    expect(fit[1].cuts, hasLength(3));
    expect(fit[1].cuts, containsAll([d1, d2, d3]));
    expect(fit[2].cuts, hasLength(2));
    expect(fit[2].cuts, containsAll([d2, d3]));
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // // Build our app and trigger a frame.
    // await tester.pumpWidget(MyApp());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
