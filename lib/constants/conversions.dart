import 'package:decimal/decimal.dart';

final Decimal inchToMm = Decimal.parse("25.4");

final Decimal mmToInch = inchToMm.inverse;
