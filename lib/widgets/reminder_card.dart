import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../services/notification_service.dart';


class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active),
                const SizedBox(width: 8),
                Text(
                  'Reminders',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<WaterProvider>(
              builder: (context, waterProvider, child) {
                return SwitchListTile(
                  title: const Text('Enable Reminders'),
                  value: waterProvider.remindersEnabled,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    waterProvider.setRemindersEnabled(value);
                    if (value) {
                      NotificationService().scheduleReminders();
                    } else {
                      NotificationService().cancelAllNotifications();
                    }
                  },
                );
              },
            ),
            const Divider(),
            const Text('Remind me in:'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
        ),
      ),
    );
  }
  
  Widget _buildReminderChip(BuildContext context, int value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: const Icon(Icons.alarm, size: 18),
        label: Text('$value $unit'),
        onPressed: () {
          final minutes = unit == 'minutes' ? value : value * 60;
          NotificationService().scheduleReminderIn(minutes);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reminder set for $value $unit from now'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
