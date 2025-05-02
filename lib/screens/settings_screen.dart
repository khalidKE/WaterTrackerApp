import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:water_tracker/screens/SignUp_Screen.dart';
import 'package:water_tracker/screens/profile_screen.dart';

import '../providers/theme_provider.dart';
import '../providers/water_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Helper method to determine icon color based on theme
  Color _getIconColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white70 : Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedTheme(
          data: theme,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    background: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isDarkMode
                                  ? [
                                    Colors.blueGrey.shade900,
                                    Colors.blueGrey.shade700,
                                  ]
                                  : [
                                    Colors.blue.shade400,
                                    Colors.blue.shade200,
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    // Profile Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: _getIconColor(context),
                            child: Icon(
                              Icons.person,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                          title: const Text(
                            'User Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('Manage your account settings'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: _getIconColor(context),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Theme Settings
                    _buildSectionHeader(
                      context,
                      'Appearance',
                      MdiIcons.palette,
                    ),
                    _buildCard(
                      context,
                      child: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return SwitchListTile(
                            title: const Text(
                              'Dark Mode',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Enable dark theme for better visibility',
                            ),
                            value: themeProvider.isDarkMode,
                            activeColor: _getIconColor(context),
                            onChanged: (value) {
                              HapticFeedback.lightImpact();
                              themeProvider.toggleTheme();
                            },
                            secondary: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: RotationTransition(
                                turns: Tween(begin: 0.0, end: 0.5).animate(
                                  CurvedAnimation(
                                    parent: AnimationController(
                                      vsync: Navigator.of(context),
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      value:
                                          themeProvider.isDarkMode ? 1.0 : 0.0,
                                    )..forward(),
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.8, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: AnimationController(
                                        vsync: Navigator.of(context),
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        value:
                                            themeProvider.isDarkMode
                                                ? 1.0
                                                : 0.0,
                                      )..forward(),
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: Icon(
                                    themeProvider.isDarkMode
                                        ? Icons.nightlight_round
                                        : Icons.wb_sunny,
                                    color: _getIconColor(context),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Notification Settings
                    _buildSectionHeader(
                      context,
                      'Notifications',
                      MdiIcons.bell,
                    ),
                    _buildCard(
                      context,
                      child: Consumer<WaterProvider>(
                        builder: (context, waterProvider, child) {
                          return SwitchListTile(
                            title: const Text(
                              'Reminder Notifications',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Receive timely reminders to stay hydrated',
                            ),
                            value: waterProvider.remindersEnabled,
                            activeColor: _getIconColor(context),
                            onChanged: (value) {
                              HapticFeedback.lightImpact();
                              waterProvider.setRemindersEnabled(value);
                              if (value) {
                                NotificationService().scheduleReminders();
                              } else {
                                NotificationService().cancelAllNotifications();
                              }
                            },
                            secondary: Icon(
                              MdiIcons.clockOutline,
                              color: _getIconColor(context),
                            ),
                          );
                        },
                      ),
                    ),

                    // Units Settings
                    _buildSectionHeader(context, 'Units', MdiIcons.ruler),
                    _buildCard(
                      context,
                      child: Consumer<WaterProvider>(
                        builder: (context, waterProvider, child) {
                          return Column(
                            children: [
                              RadioListTile<String>(
                                title: const Text('Milliliters (ml)'),
                                subtitle: const Text('Metric system'),
                                value: 'ml',
                                groupValue: waterProvider.unit,
                                activeColor: _getIconColor(context),
                                onChanged: (value) {
                                  HapticFeedback.lightImpact();
                                  if (value != null) {
                                    waterProvider.setUnit(value);
                                  }
                                },
                                secondary: Icon(
                                  MdiIcons.water,
                                  color: _getIconColor(context),
                                ),
                              ),
                              RadioListTile<String>(
                                title: const Text('Fluid Ounces (oz)'),
                                subtitle: const Text('Imperial system'),
                                value: 'oz',
                                groupValue: waterProvider.unit,
                                activeColor: _getIconColor(context),
                                onChanged: (value) {
                                  HapticFeedback.lightImpact();
                                  if (value != null) {
                                    waterProvider.setUnit(value);
                                  }
                                },
                                secondary: Icon(
                                  MdiIcons.water,
                                  color: _getIconColor(context),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // App Settings
                    _buildSectionHeader(context, 'App Settings', MdiIcons.cog),

                    _buildCard(
                      context,
                      child: ListTile(
                        title: const Text(
                          'Log out',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Are you sure you want to Log out?',
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: _getIconColor(context),
                        ),
                        leading: Icon(MdiIcons.logout, color: Colors.redAccent),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text('Log out'),
                                  content: const Text(
                                    'Are you sure you want to Log out? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Clear all data
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const SignupScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'Log out',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ),
                    // About
                    _buildSectionHeader(context, 'About', MdiIcons.information),
                    _buildCard(
                      context,
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              'App Version',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text('1.0.0'),
                            leading: Icon(
                              MdiIcons.tag,
                              color: _getIconColor(context),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: _getIconColor(context),
                            ),
                            leading: Icon(
                              MdiIcons.shieldLock,
                              color: _getIconColor(context),
                            ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Open privacy policy
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Terms of Service',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: _getIconColor(context),
                            ),
                            leading: Icon(
                              MdiIcons.fileDocument,
                              color: _getIconColor(context),
                            ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Open terms of service
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: _getIconColor(context), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(color: Theme.of(context).cardColor, child: child),
        ),
      ),
    );
  }
}
