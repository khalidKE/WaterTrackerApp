import 'package:flutter/material.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    // This would be replaced with actual data from the provider
    final monthData = List.generate(30, (index) {
      final day = index + 1;
      final amount = 1500 + (day % 7) * 200;
      return {'day': day, 'amount': amount, 'goal': 2000};
    });
    
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: MonthlyChartPainter(
          data: monthData,
          lineColor: Theme.of(context).colorScheme.primary,
          goalLineColor: Colors.red,
        ),
        size: const Size(double.infinity, 200),
      ),
    );
  }
}

class MonthlyChartPainter extends CustomPainter {
  final List<Map<String, int>> data;
  final Color lineColor;
  final Color goalLineColor;
  
  MonthlyChartPainter({
    required this.data,
    required this.lineColor,
    required this.goalLineColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Draw goal line
    final goalPaint = Paint()
      ..color = goalLineColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final goalY = height - (height * (data[0]['goal']! / 3000));
    
    canvas.drawLine(
      Offset(0, goalY),
      Offset(width, goalY),
      goalPaint,
    );
    
    // Draw data line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = width * (i / (data.length - 1));
      final y = height - (height * (data[i]['amount']! / 3000));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, linePaint);
    
    // Draw data points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < data.length; i++) {
      final x = width * (i / (data.length - 1));
      final y = height - (height * (data[i]['amount']! / 3000));
      
      // Only draw points for every 5th day to avoid clutter
      if (i % 5 == 0) {
        canvas.drawCircle(Offset(x, y), 3, pointPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant MonthlyChartPainter oldDelegate) {
    return oldDelegate.data != data ||
           oldDelegate.lineColor != lineColor ||
           oldDelegate.goalLineColor != goalLineColor;
  }
}
