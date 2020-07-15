import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../model/fittings.dart';

class FitSummary extends StatelessWidget {
  final Fit fit;

  const FitSummary({Key key, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${fit.totalLen}\" Board, ${fit.cuts.length} cuts"),
          SizedBox(
            height: 60,
            child: CustomPaint(size: Size.infinite, painter: _FitPainter(fit)),
          ),
        ],
      ),
    );
  }
}

class _FitPainter extends CustomPainter {
  final Fit fit;
  final Decimal scale;

  _FitPainter(this.fit, [Decimal scale]) : this.scale = scale ?? Decimal.one;

  @override
  void paint(Canvas canvas, Size size) {
    var bounds = Offset.zero & size;

    // TODO handle scale

    var boardColor = Color.fromARGB(255, 255, 224, 157);

    // Board backing
    canvas.drawRect(
      bounds,
      Paint()..color = boardColor,
    );
    // Board border
    canvas.drawRect(
      bounds,
      Paint()
        ..color = boardColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    var left = 0.0;
    final height = size.height / 2;
    fit.cuts.forEach((cutWidth) {
      final relativeWidth = cutWidth / fit.totalLen;
      final width = size.width * relativeWidth.toDouble();
      final right = left + width;

      // Cut line segment
      canvas.drawPath(
        Path()
          ..moveTo(left, height / 2)
          ..lineTo(left, height + height / 2)
          ..moveTo(left, height)
          ..lineTo(right, height)
          ..moveTo(right, height / 2)
          ..lineTo(right, height + height / 2)
          ..close(),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );

      // Description of length
      final textPainter = TextPainter(
        text: TextSpan(
          text: "$cutWidth\"",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(
          minWidth: 0,
          maxWidth: width,
        );

      textPainter.paint(
          canvas,
          Offset(
            (left + width / 2) - textPainter.width / 2,
            height / 2,
          ));

      left = right;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
