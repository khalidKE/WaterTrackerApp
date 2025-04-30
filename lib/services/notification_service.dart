import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }
  
  Future<void> scheduleReminders() async {
    // Cancel any existing notifications
    await cancelAllNotifications();
    
    // Schedule notifications throughout the day
    final now = DateTime.now();
    
    // Morning reminder (9 AM)
    await _scheduleNotification(
      id: 1,
      title: 'Morning Hydration',
      body: 'Start your day right with a glass of water!',
      scheduledTime: DateTime(
        now.year,
        now.month,
        now.day,
        9,
        0,
      ),
    );
    
    // Lunch reminder (12 PM)
    await _scheduleNotification(
      id: 2,
      title: 'Lunch Time Hydration',
      body: 'Remember to drink water with your lunch!',
      scheduledTime: DateTime(
        now.year,
        now.month,
        now.day,
        12,
        0,
      ),
    );
    
    // Afternoon reminder (3 PM)
    await _scheduleNotification(
      id: 3,
      title: 'Afternoon Hydration',
      body: 'Beat the afternoon slump with a refreshing drink!',
      scheduledTime: DateTime(
        now.year,
        now.month,
        now.day,
        15,
        0,
      ),
    );
    
    // Evening reminder (6 PM)
    await _scheduleNotification(
      id: 4,
      title: 'Evening Hydration',
      body: 'Don\'t forget to stay hydrated in the evening!',
      scheduledTime: DateTime(
        now.year,
        now.month,
        now.day,
        18,
        0,
      ),
    );
  }
  
  Future<void> scheduleReminderIn(int minutes) async {
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: minutes));
    
    await _scheduleNotification(
      id: 100, // Use a different ID range for manual reminders
      title: 'Hydration Reminder',
      body: 'Time to drink some water!',
      scheduledTime: scheduledTime,
    );
  }
  
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Skip if the scheduled time is in the past
    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_tracker_channel',
          'Water Tracker Notifications',
          channelDescription: 'Notifications for water tracking reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Updated parameter
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
