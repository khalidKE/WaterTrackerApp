import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/water_provider.dart';
import '../services/notification_service.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          
          const Divider(),
          
          // Notification settings
          const ListTile(
            title: Text('Notification Settings'),
            leading: Icon(Icons.notifications),
          ),
          Consumer<WaterProvider>(
            builder: (context, waterProvider, child) {
              return SwitchListTile(
                title: const Text('Reminder Notifications'),
                subtitle: const Text('Get reminders to drink water'),
                value: waterProvider.remindersEnabled,
                onChanged: (value) {
                  waterProvider.setRemindersEnabled(value);
                  if (value) {
                    NotificationService().scheduleReminders();
                  } else {
                    NotificationService().cancelAllNotifications();
                  }
                },
                secondary: const Icon(Icons.access_time),
              );
            },
          ),
          ListTile(
            title: const Text('Reminder Frequency'),
            subtitle: const Text('How often to receive reminders'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to reminder frequency settings
            },
          ),
          
          const Divider(),
          
          // Units settings
          const ListTile(
            title: Text('Units Settings'),
            leading: Icon(Icons.straighten),
          ),
          Consumer<WaterProvider>(
            builder: (context, waterProvider, child) {
              return RadioListTile<String>(
                title: const Text('Milliliters (ml)'),
                value: 'ml',
                groupValue: waterProvider.unit,
                onChanged: (value) {
                  if (value != null) {
                    waterProvider.setUnit(value);
                  }
                },
              );
            },
          ),
          Consumer<WaterProvider>(
            builder: (context, waterProvider, child) {
              return RadioListTile<String>(
                title: const Text('Fluid Ounces (oz)'),
                value: 'oz',
                groupValue: waterProvider.unit,
                onChanged: (value) {
                  if (value != null) {
                    waterProvider.setUnit(value);
                  }
                },
              );
            },
          ),
          
          const Divider(),
          
          // App settings
          const ListTile(
            title: Text('App Settings'),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: const Text('Backup & Restore'),
            subtitle: const Text('Backup your data to the cloud'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to backup settings
            },
          ),
          ListTile(
            title: const Text('Clear Data'),
            subtitle: const Text('Delete all app data'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Data'),
                  content: const Text('Are you sure you want to delete all app data? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Clear all data
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const Divider(),
          
          // About
          const ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open terms of service
            },
          ),
        ],
      ),
    );
  }
}
