import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/water_provider.dart';
import '../services/notification_service.dart';

class ReminderCard extends StatefulWidget {
  const ReminderCard({super.key});

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  bool showReminderOptions =
      true; // Controls visibility of "Remind me in" section

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color:
          isDarkMode
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Smart Reminders',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<WaterProvider>(
              builder: (context, waterProvider, child) {
                return SwitchListTile(
                  title: const Text(
                    'Enable Reminders',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Get notifications to stay hydrated',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: waterProvider.remindersEnabled,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    waterProvider.setRemindersEnabled(value);
                    setState(() {
                      showReminderOptions =
                          value; // Show/hide options based on switch
                    });
                    if (value) {
                      NotificationService().scheduleReminders();
                    } else {
                      NotificationService().cancelAllNotifications();
                    }
                  },
                );
              },
            ),
            if (showReminderOptions &&
                Provider.of<WaterProvider>(context).remindersEnabled) ...[
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
                    _buildReminderChip(context, 10, 'minutes'),
                    _buildReminderChip(context, 30, 'minutes'),
                    _buildReminderChip(context, 1, 'hour'),
                    _buildReminderChip(context, 2, 'hours'),
                  ],
                ),
              ),
            ],
          ],
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
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
        onPressed: () {
          final minutes = unit == 'minutes' ? value : value * 60;
          NotificationService().scheduleReminderIn(minutes);
          setState(() {
            showReminderOptions = false; // Hide "Remind me in" section
          });
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
