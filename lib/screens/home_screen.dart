import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/drink.dart';
import '../providers/water_provider.dart';
import '../widgets/add_water_dialog.dart';
import '../widgets/recent_drinks.dart';
import '../widgets/reminder_card.dart';
import '../widgets/water_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        final progress = waterProvider.getTodayProgress();
        final goal = waterProvider.dailyGoal;
        final todayTotal = waterProvider.getTodayTotal();
        final percentage = (todayTotal / goal * 100).clamp(0, 100).toInt();

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  backgroundColor:
                      isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.white,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Hydrate',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // Show notifications
                      },
                    ),
                    IconButton(
                      icon: CircleAvatar(
                        radius: 14,
                        backgroundImage: const AssetImage(
                          'images/small_glass.png',
                        ),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                      onPressed: () {
                        // Show profile
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Date and greeting
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'EEEE, MMMM d',
                                  ).format(DateTime.now()),
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    percentage >= 100
                                        ? Colors.green.withOpacity(0.2)
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    percentage >= 100
                                        ? Icons.check_circle
                                        : Icons.water_drop,
                                    size: 16,
                                    color:
                                        percentage >= 100
                                            ? Colors.green
                                            : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    percentage >= 100
                                        ? 'Goal Achieved!'
                                        : '$percentage% of goal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          percentage >= 100
                                              ? Colors.green
                                              : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Water progress widget with enhanced design
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _isExpanded ? 300 : 220,
                          constraints: const BoxConstraints(minHeight: 220),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color:
                                isDarkMode
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.05),
                            child: InkWell(
                              onTap: _toggleExpanded,
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Daily Progress',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: AnimatedIcon(
                                            icon: AnimatedIcons.menu_close,
                                            progress: _animationController,
                                          ),
                                          onPressed: _toggleExpanded,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: WaterProgress(
                                        progress: todayTotal,
                                        goal: goal,
                                        isExpanded: _isExpanded,
                                      ),
                                    ),
                                    if (_isExpanded) ...[
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildStatItem(
                                            context,
                                            '$todayTotal ml',
                                            'Consumed',
                                            Icons.water_drop,
                                          ),
                                          _buildStatItem(
                                            context,
                                            '$goal ml',
                                            'Goal',
                                            Icons.flag,
                                          ),
                                          _buildStatItem(
                                            context,
                                            '${waterProvider.getTodayDrinks().length}',
                                            'Drinks',
                                            Icons.local_drink,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quick add buttons with enhanced design
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quick Add',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Custom'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AddWaterDialog(),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildQuickAddCard(
                                context,
                                waterProvider,
                                100,
                                'Small',
                                'images/small_glass.png',
                              ),
                              _buildQuickAddCard(
                                context,
                                waterProvider,
                                200,
                                'Medium',
                                'images/medium_glass.png',
                              ),
                              _buildQuickAddCard(
                                context,
                                waterProvider,
                                300,
                                'Large',
                                'images/large_glass.png',
                              ),
                              _buildQuickAddCard(
                                context,
                                waterProvider,
                                500,
                                'Bottle',
                                'images/bottle.png',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Enhanced reminder card
                        const ReminderCard(),

                        const SizedBox(height: 24),

                        // Recent drinks with enhanced design
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Today\'s Drinks',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        RecentDrinks(drinks: waterProvider.getTodayDrinks()),
                        const SizedBox(height: 80), // Extra space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddWaterDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Drink'),
            elevation: 4,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildQuickAddCard(
    BuildContext context,
    WaterProvider waterProvider,
    int amount,
    String label,
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () {
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
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 40, width: 40),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '$amount ml',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
