import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:water_tracker/screens/SignUp_Screen.dart';
import 'package:water_tracker/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
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

  // Method to launch email client
  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'abuelhassan179@gmail.com',
      query: 'subject=Support Request&body=Please describe your issue:',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not launch email client'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error launching email client'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
                                                (context) =>
                                                    const SignupScreen(),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Support',
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Contact support at abuelhassan179@gmail.com',
                                  ),
                                  backgroundColor: _getIconColor(context),
                                  duration: const Duration(seconds: 4),
                                  action: SnackBarAction(
                                    label: 'Email',
                                    textColor:
                                        isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                    onPressed: () => _launchEmail(context),
                                  ),
                                ),
                              );
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

// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''
Privacy Policy

Last updated: May 3, 2025

Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Water Tracker application.

1. Information We Collect
We may collect the following types of information:
- Personal Information: Name, email address, and other information you provide during registration.
- Usage Data: Information about how you use the app, such as water intake logs and notification preferences.
- Device Information: Device type, operating system, and unique device identifiers.

2. How We Use Your Information
We use the collected information to:
- Provide and improve the app's functionality.
- Send you reminders and notifications to stay hydrated.
- Analyze app usage to enhance user experience.

3. Sharing Your Information
We do not share your personal information with third parties except:
- With your consent.
- To comply with legal obligations.
- To protect our rights and safety.

4. Data Security
We implement reasonable security measures to protect your information. However, no method of transmission over the internet is 100% secure.

5. Your Choices
You can:
- Update your profile information.
- Opt-out of notifications in the app settings.
- Request deletion of your account by contacting support.

6. Changes to This Privacy Policy
We may update this policy from time to time. We will notify you of any changes by posting the new policy in the app.

7. Contact Us
If you have any questions about this Privacy Policy, please contact us at abuelhassan179@gmail.com.
            ''', style: GoogleFonts.poppins(fontSize: 16, height: 1.5)),
        ),
      ),
    );
  }
}
