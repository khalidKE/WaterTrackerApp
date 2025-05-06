import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class TestNotificationButton extends StatelessWidget {
  const TestNotificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show a notification after 10 seconds for testing
        final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
        NotificationService().scheduleNotification(
          id: 999,
          title: 'Test Notification',
          body:
              'This is a test notification to verify it works outside the app',
          scheduledDate: scheduledTime,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Test notification scheduled for 10 seconds from now. Close the app to test.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_active),
          SizedBox(width: 8),
          Text('Test Outside Notification'),
        ],
      ),
    );
  }
}
