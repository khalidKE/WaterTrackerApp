import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../widgets/achievement_list.dart';
import '../widgets/goal_calculator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<WaterProvider>(
        builder: (context, waterProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'User Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Daily Goal: ${waterProvider.dailyGoal} ml',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const GoalCalculator(),
                            );
                          },
                          child: const Text('Recalculate Daily Goal'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Personal info
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.monitor_weight),
                        title: const Text('Weight'),
                        subtitle: const Text('70 kg'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Edit weight
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.height),
                        title: const Text('Height'),
                        subtitle: const Text('175 cm'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Edit height
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.fitness_center),
                        title: const Text('Activity Level'),
                        subtitle: const Text('Moderate'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Edit activity level
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Achievements
                Text(
                  'Achievements',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const AchievementList(),
                
                const SizedBox(height: 24),
                
                // Challenges
                Text(
                  'Active Challenges',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.emoji_events, color: Colors.white),
                        ),
                        title: const Text('7-Day Streak'),
                        subtitle: const Text('Drink your goal for 7 days in a row'),
                        trailing: const Text('3/7'),
                      ),
                      const LinearProgressIndicator(value: 3/7),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.local_fire_department, color: Colors.white),
                        ),
                        title: const Text('Morning Hydration'),
                        subtitle: const Text('Drink 300ml within 30 minutes of waking up'),
                        trailing: const Text('5/10'),
                      ),
                      const LinearProgressIndicator(value: 5/10),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
