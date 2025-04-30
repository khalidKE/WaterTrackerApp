import 'package:flutter/material.dart';

import 'water_wave.dart';

class WaterProgress extends StatelessWidget {
  final int progress;
  final int goal;
  
  const WaterProgress({
    super.key,
    required this.progress,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress / goal).clamp(0.0, 1.0);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$progress / $goal ml',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Water wave animation
                  WaterWave(
                    percentage: percentage,
                  ),
                  
                  // Percentage text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: percentage > 0.5 ? Colors.white : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        'of daily goal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: percentage > 0.5 ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
