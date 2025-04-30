import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drink.dart';
import '../providers/water_provider.dart';
import '../widgets/add_water_dialog.dart';
import '../widgets/recent_drinks.dart';
import '../widgets/reminder_card.dart';
import '../widgets/water_progress.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        final progress = waterProvider.getTodayProgress();
        final goal = waterProvider.dailyGoal;
        
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  title: const Text(
                    'Water Tracker',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // Show notifications
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Water progress widget
                        WaterProgress(
                          progress: progress.toInt(),
                          goal: goal,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Quick add buttons
                        Text(
                          'Quick Add',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final amount in [100, 200, 300, 500])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ActionChip(
                                    avatar: const Icon(Icons.water_drop, size: 18),
                                    label: Text('$amount ml'),
                                    onPressed: () {
                                      waterProvider.addDrink(
                                        Drink(
                                          type: DrinkType.water,
                                          amount: amount,
                                          timestamp: DateTime.now(),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added $amount ml of water'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Reminder card
                        const ReminderCard(),
                        
                        const SizedBox(height: 24),
                        
                        // Recent drinks
                        Text(
                          'Today\'s Drinks',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RecentDrinks(drinks: waterProvider.getTodayDrinks()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddWaterDialog(),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
