import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../providers/water_provider.dart';
import '../widgets/achievement_calendar.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/weekly_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Consumer<WaterProvider>(
        builder: (context, waterProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Daily statistics
              _buildDailyStatistics(waterProvider),
              
              // Weekly statistics
              _buildWeeklyStatistics(waterProvider),
              
              // Monthly statistics
              _buildMonthlyStatistics(waterProvider),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDailyStatistics(WaterProvider waterProvider) {
    final todayDrinks = waterProvider.getTodayDrinks();
    final todayTotal = waterProvider.getTodayTotal();
    final goal = waterProvider.dailyGoal;
    final percentage = (todayTotal / goal * 100).clamp(0, 100).toInt();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        '$percentage%',
                        'Progress',
                        Icons.show_chart,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Drink Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Placeholder for pie chart
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Drink Type Distribution Chart'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Hourly Consumption',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Placeholder for hourly chart
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Hourly Consumption Chart'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyStatistics(WaterProvider waterProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  const WeeklyChart(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Achievement Calendar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          const AchievementCalendar(),
        ],
      ),
    );
  }
  
  Widget _buildMonthlyStatistics(WaterProvider waterProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Month',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  const MonthlyChart(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Monthly Trends',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Placeholder for monthly trends
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Monthly Trends Chart'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
