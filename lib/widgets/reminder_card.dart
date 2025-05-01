import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/water_provider.dart';
import '../services/notification_service.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDarkMode ? 0 : 2,
      shadowColor:
          isDarkMode ? Colors.transparent : Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<WaterProvider>(
          builder: (context, waterProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(
                    'Enable Reminders',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Get notifications to stay hydrated',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  value: waterProvider.remindersEnabled,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    waterProvider.setRemindersEnabled(value);
                    if (value) {
                      NotificationService().scheduleReminders();
                    } else {
                      NotificationService().cancelAllNotifications();
                    }
                  },
                ),
                if (waterProvider.remindersEnabled) ...[
                  const Divider(),
                  const Text(
                    'Remind me in:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildReminderChip(context, 5, 'minutes'),
                        _buildReminderChip(context, 10, 'minutes'),
                        _buildReminderChip(context, 15, 'minutes'),
                        _buildReminderChip(context, 20, 'minutes'),
                        _buildReminderChip(context, 30, 'minutes'),
                        _buildReminderChip(context, 1, 'hour'),
                        _buildReminderChip(context, 2, 'hours'),
                        _buildReminderChip(context, 4, 'hours'),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReminderChip(BuildContext context, int value, String unit) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(
          Icons.alarm,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text('$value $unit'),
        backgroundColor:
            isDarkMode
                ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
                : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
        onPressed: () {
          final minutes = unit == 'minutes' ? value : value * 60;
          NotificationService().scheduleReminderIn(minutes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reminder set for $value $unit from now'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
