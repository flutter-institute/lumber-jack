import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumber_jack/model/cuts.dart';
import 'package:lumber_jack/model/dimensions.dart';
import 'package:lumber_jack/model/fittings.dart';

import 'package:lumber_jack/util/make_fit.dart';

void main() {
  test('handles conversion factors', () {
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

  test('groups a lot of cuts properly', () {
    final d1 = Decimal.fromInt(72);
    final d2 = Decimal.fromInt(56);
    final d3 = Decimal.parse('43.25');
    final d4 = Decimal.fromInt(33);
    final d5 = Decimal.parse('32.25');
    final d6 = Decimal.parse('31.75');
    final d7 = Decimal.fromInt(26);
    final d8 = Decimal.fromInt(18);

    final cutGroup = CutGroup()
      ..maxLen = Decimal.fromInt(96)
      ..sawWidth = Decimal.parse("0.25")
      ..dimensions = DimensionItem.twoByFour
      ..cuts = [
        CutDesc(d1, 6),
        CutDesc(d2, 4),
        CutDesc(d3, 6),
        CutDesc(d4, 4),
        CutDesc(d5, 6),
        CutDesc(d6, 2),
        CutDesc(d7, 3),
        CutDesc(d8, 4),
      ];

    final fit = makeFit(cutGroup);

    expect(fit, hasLength(17));
    expect(fit[0].cuts, hasLength(2));
    expect(fit[0].cuts, containsAll([d1, d8]));
    expect(fit[1].cuts, hasLength(2));
    expect(fit[1].cuts, containsAll([d1, d8]));
    expect(fit[2].cuts, hasLength(2));
    expect(fit[2].cuts, containsAll([d1, d8]));
    expect(fit[3].cuts, hasLength(2));
    expect(fit[3].cuts, containsAll([d1, d8]));
    expect(fit[4].cuts, hasLength(1));
    expect(fit[4].cuts, contains(d1));
    expect(fit[5].cuts, hasLength(1));
    expect(fit[5].cuts, contains(d1));
    expect(fit[6].cuts, hasLength(2));
    expect(fit[6].cuts, containsAll([d2, d4]));
    expect(fit[7].cuts, hasLength(2));
    expect(fit[7].cuts, containsAll([d2, d4]));
    expect(fit[8].cuts, hasLength(2));
    expect(fit[8].cuts, containsAll([d2, d4]));
    expect(fit[9].cuts, hasLength(2));
    expect(fit[9].cuts, containsAll([d2, d4]));
    expect(fit[10].cuts, hasLength(2));
    expect(fit[10].cuts, contains(d3));
    expect(fit[11].cuts, hasLength(2));
    expect(fit[11].cuts, contains(d3));
    expect(fit[12].cuts, hasLength(2));
    expect(fit[12].cuts, contains(d3));
    expect(fit[13].cuts, hasLength(3));
    expect(fit[13].cuts, containsAll([d5, d7]));
    expect(fit[14].cuts, hasLength(3));
    expect(fit[14].cuts, containsAll([d5, d7]));
    expect(fit[15].cuts, hasLength(3));
    expect(fit[15].cuts, containsAll([d5, d7]));
    expect(fit[16].cuts, hasLength(2));
    expect(fit[16].cuts, contains(d6));
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
