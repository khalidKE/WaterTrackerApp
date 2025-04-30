import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';

class AchievementCalendar extends StatelessWidget {
  const AchievementCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final monthData = waterProvider.getMonthlyData();
        final goal = waterProvider.dailyGoal;

        // Determine which days achieved the goal
        final achievedDays = <int>{};
        for (int i = 0; i < monthData.length; i++) {
          if ((monthData[i]['amount'] as int) >= goal) {
            achievedDays.add(i + 1); // Days are 1-indexed
          }
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(now),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: daysInMonth,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final isAchieved = achievedDays.contains(day);
                    final isToday = day == now.day;
                    final isPast = day < now.day;

                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                            isAchieved
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.7)
                                : isPast
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            isToday
                                ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                                : isPast
                                ? Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1,
                                )
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: isAchieved ? Colors.white : null,
                            fontWeight: isToday ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Goal achieved'),
                    const SizedBox(width: 16),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Goal not achieved'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
