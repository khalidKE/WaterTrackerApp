import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterProgress extends StatefulWidget {
  final int progress;
  final int goal;
  final bool isExpanded;

  const WaterProgress({
    super.key,
    required this.progress,
    required this.goal,
    this.isExpanded = false,
  });

  @override
  State<WaterProgress> createState() => _WaterProgressState();
}

class _WaterProgressState extends State<WaterProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress / widget.goal,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(WaterProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress / widget.goal,
        end: widget.progress / widget.goal,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.progress / widget.goal).clamp(0.0, 1.0);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Circular progress indicator
            SizedBox(
              height:
                  widget.isExpanded
                      ? 200
                      : 150, // Increased sizes for better visibility
              width: widget.isExpanded ? 200 : 150,
              child: CustomPaint(
                painter: WaveProgressPainter(
                  animationValue: _animationController.value,
                  percentage: _progressAnimation.value.clamp(0.0, 1.0),
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      isDarkMode
                          ? Colors.grey.shade800
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),

            // Percentage text
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize:
                          widget.isExpanded ? 28 : 25, // Adjusted font size
                      fontWeight: FontWeight.bold,
                      color:
                          percentage > 0.5 && !isDarkMode ? Colors.white : null,
                    ),
                  ),
                  Text(
                    '${widget.progress} / ${widget.goal} ml',
                    style: TextStyle(
                      fontSize:
                          widget.isExpanded ? 10 : 12, // Adjusted font size
                      color:
                          percentage > 0.5 && !isDarkMode
                              ? Colors.white.withOpacity(0.9)
                              : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double animationValue;
  final double percentage;
  final Color color;
  final Color backgroundColor;

  WaveProgressPainter({
    required this.animationValue,
    required this.percentage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = math.min(width, height) / 2;
    final center = Offset(width / 2, height / 2);

    // Draw background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw border
    final borderPaint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3; // Slightly thicker border for larger circle

    canvas.drawCircle(center, radius, borderPaint);

    if (percentage == 0) return;

    // Create a clipping path for the circle
    final clipPath =
        Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.clipPath(clipPath);

    // Calculate wave parameters
    final waveHeight = radius * 0.15; // Adjusted for larger circle
    final waveCount = 2.0;
    final baseHeight = height - percentage * height;

    // Create wave path
    final wavePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final wavePath = Path();
    wavePath.moveTo(0, baseHeight);

    for (double i = 0; i <= width; i++) {
      final dx = i;
      final dy =
          baseHeight +
          math.sin(
                (i / width * waveCount * 2 * math.pi) +
                    (animationValue * 2 * math.pi),
              ) *
              waveHeight;
      wavePath.lineTo(dx, dy);
    }

    // Complete the path
    wavePath.lineTo(width, height);
    wavePath.lineTo(0, height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant WaveProgressPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.percentage != percentage ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
