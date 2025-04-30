import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    // This would be replaced with actual data from the provider
    final weekData = [
      {'day': 'Mon', 'amount': 1800, 'goal': 2000},
      {'day': 'Tue', 'amount': 2100, 'goal': 2000},
      {'day': 'Wed', 'amount': 1500, 'goal': 2000},
      {'day': 'Thu', 'amount': 2300, 'goal': 2000},
      {'day': 'Fri', 'amount': 1900, 'goal': 2000},
      {'day': 'Sat', 'amount': 2200, 'goal': 2000},
      {'day': 'Sun', 'amount': 1700, 'goal': 2000},
    ];
    
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: weekData.map((day) {
            final percentage = (day['amount'] as num) / (day['goal'] as num);
            final color = percentage >= 1.0 
                ? Colors.green 
                : Theme.of(context).colorScheme.primary;
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${day['amount']}',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 120 * percentage.clamp(0.0, 1.5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(day['day'] as String),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
