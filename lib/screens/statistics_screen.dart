import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import '../providers/water_provider.dart';
import '../widgets/achievement_calendar.dart';
import '../models/drink.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          controller: (controller) => _animationController,
          child: Text(
            'Water Insights',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: isDarkMode ? null : Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [Colors.grey[900]!, Colors.grey[800]!]
                    : [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Consumer<WaterProvider>(
          builder: (context, waterProvider, child) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildDailyStatistics(waterProvider),
                _buildWeeklyStatistics(waterProvider),
                _buildMonthlyStatistics(waterProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDailyStatistics(WaterProvider waterProvider) {
    final todayDrinks = waterProvider.getTodayDrinks();
    final todayTotal = waterProvider.getTodayTotal();
    final goal = waterProvider.dailyGoal;
    final percentage = (todayTotal / goal * 100).clamp(0, 100).toInt();

    final Map<DrinkType, int> drinkDistribution = {};
    for (var drink in todayDrinks) {
      drinkDistribution[drink.type] =
          (drinkDistribution[drink.type] ?? 0) + drink.amount;
    }

    final Map<int, int> hourlyConsumption = {};
    for (var drink in todayDrinks) {
      final hour = drink.timestamp.hour;
      hourlyConsumption[hour] = (hourlyConsumption[hour] ?? 0) + drink.amount;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today’s Hydration',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnimatedStatItem(
                          context,
                          '$todayTotal ml',
                          'Consumed',
                          Icons.water_drop,
                        ),
                        _buildAnimatedStatItem(
                          context,
                          '$goal ml',
                          'Goal',
                          Icons.flag,
                        ),
                        _buildAnimatedStatItem(
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
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            controller: (controller) => _animationController,
            child: Text(
              'Drink Distribution',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 220,
                  child:
                      drinkDistribution.isEmpty
                          ? Center(
                            child: Text(
                              'No drinks recorded today',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          )
                          : PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 50,
                              sections: _buildPieChartSections(
                                drinkDistribution,
                              ),
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {},
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            controller: (controller) => _animationController,
            child: Text(
              'Hourly Consumption',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 220,
                  child:
                      hourlyConsumption.isEmpty
                          ? Center(
                            child: Text(
                              'No drinks recorded today',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          )
                          : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _getMaxHourlyConsumption(hourlyConsumption),
                              barGroups: _buildHourlyBarGroups(
                                hourlyConsumption,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (
                                      double value,
                                      TitleMeta meta,
                                    ) {
                                      return SideTitleWidget(
                                        meta: meta,
                                        space: 6,
                                        child: Text(
                                          '${value.toInt()}:00',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                    reservedSize: 32,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (
                                      double value,
                                      TitleMeta meta,
                                    ) {
                                      return SideTitleWidget(
                                        meta: meta,

                                        space: 6,
                                        child: Text(
                                          '${value.toInt()} ml',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 100,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatistics(WaterProvider waterProvider) {
    final weekData = waterProvider.getWeeklyData();
    final weeklyTotal = weekData.fold(
      0,
      (sum, day) => sum + (day['amount'] as int),
    );
    final weeklyAverage = weekData.isEmpty ? 0 : weeklyTotal ~/ weekData.length;
    final goal = waterProvider.dailyGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Overview',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnimatedStatItem(
                          context,
                          '$weeklyTotal ml',
                          'Total',
                          Icons.water_drop,
                        ),
                        _buildAnimatedStatItem(
                          context,
                          '$weeklyAverage ml',
                          'Daily Avg',
                          Icons.trending_up,
                        ),
                        _buildAnimatedStatItem(
                          context,
                          '${weekData.where((day) => (day['amount'] as int) >= goal).length}',
                          'Goal Days',
                          Icons.emoji_events,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child:
                          weekData.isEmpty
                              ? Center(
                                child: Text(
                                  'No data for this week',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                              : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: _getMaxWeeklyConsumption(
                                    weekData,
                                    goal,
                                  ),
                                  barGroups: _buildWeeklyBarGroups(
                                    weekData,
                                    goal,
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          final days = [
                                            'Mon',
                                            'Tue',
                                            'Wed',
                                            'Thu',
                                            'Fri',
                                            'Sat',
                                            'Sun',
                                          ];
                                          final index = value.toInt();
                                          if (index >= 0 &&
                                              index < days.length) {
                                            return SideTitleWidget(
                                              meta: meta,

                                              space: 6,
                                              child: Text(
                                                days[index],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                        reservedSize: 32,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 6,
                                            child: Text(
                                              '${value.toInt()} ml',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 40,
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 500,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.2),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            controller: (controller) => _animationController,
            child: Text(
              'Achievement Calendar',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: AchievementCalendar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatistics(WaterProvider waterProvider) {
    final monthData = waterProvider.getMonthlyData();
    final monthlyTotal = monthData.fold(
      0,
      (sum, day) => sum + (day['amount'] as int),
    );
    final monthlyAverage =
        monthData.isEmpty ? 0 : monthlyTotal ~/ monthData.length;
    final goal = waterProvider.dailyGoal;
    final goalDays =
        monthData.where((day) => (day['amount'] as int) >= goal).length;
    final goalPercentage =
        monthData.isEmpty ? 0 : (goalDays / monthData.length * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Insights',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnimatedStatItem(
                          context,
                          '$monthlyTotal ml',
                          'Total',
                          Icons.water_drop,
                        ),
                        _buildAnimatedStatItem(
                          context,
                          '$monthlyAverage ml',
                          'Daily Avg',
                          Icons.trending_up,
                        ),
                        _buildAnimatedStatItem(
                          context,
                          '$goalPercentage%',
                          'Goal Days',
                          Icons.emoji_events,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child:
                          monthData.isEmpty
                              ? Center(
                                child: Text(
                                  'No data for this month',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                              : LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _buildMonthlySpots(monthData),
                                      isCurved: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ],
                                      ),
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.3),
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: List.generate(
                                        monthData.length,
                                        (index) => FlSpot(
                                          index.toDouble(),
                                          goal.toDouble(),
                                        ),
                                      ),
                                      isCurved: false,
                                      color: Colors.red.withOpacity(0.5),
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      dashArray: [5, 5],
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          if (value.toInt() % 5 == 0) {
                                            return SideTitleWidget(
                                              meta: meta,
                                              space: 6,
                                              child: Text(
                                                '${value.toInt() + 1}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                        reservedSize: 32,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 6,
                                            child: Text(
                                              '${value.toInt()} ml',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 40,
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 500,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.2),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            controller: (controller) => _animationController,
            child: Text(
              'Monthly Trends',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            controller: (controller) => _animationController,
            child: _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildTrendTile(
                      context,
                      'Best Day',
                      _getBestDay(monthData),
                      Icons.trending_up,
                      Theme.of(context).colorScheme.primary,
                    ),
                    const Divider(height: 1, color: Colors.grey),
                    _buildTrendTile(
                      context,
                      'Most Active Time',
                      _getMostActiveTime(waterProvider),
                      Icons.access_time,
                      Colors.orange,
                    ),
                    const Divider(height: 1, color: Colors.grey),
                    _buildTrendTile(
                      context,
                      'Longest Streak',
                      _getLongestStreak(monthData, goal),
                      Icons.emoji_events,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:
            isDarkMode
                ? Colors.grey[800]!.withOpacity(0.3)
                : Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color:
              isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildAnimatedStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return ElasticIn(
      controller: (controller) => _animationController,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<DrinkType, int> distribution,
  ) {
    final List<PieChartSectionData> sections = [];
    final colors = {
      DrinkType.water: Colors.blue[400]!,
      DrinkType.coffee: Colors.brown[400]!,
      DrinkType.tea: Colors.green[400]!,
      DrinkType.juice: Colors.orange[400]!,
    };

    final labels = {
      DrinkType.water: 'Water',
      DrinkType.coffee: 'Coffee',
      DrinkType.tea: 'Tea',
      DrinkType.juice: 'Juice',
    };

    final total = distribution.values.fold(0, (sum, amount) => sum + amount);

    distribution.forEach((type, amount) {
      final percentage = total > 0 ? (amount / total * 100).round() : 0;
      sections.add(
        PieChartSectionData(
          value: amount.toDouble(),
          title: '$percentage%',
          color: colors[type],
          radius: 90,
          titleStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          badgeWidget: _Badge(labels[type] ?? '', colors[type]!),
          badgePositionPercentageOffset: 1.3,
        ),
      );
    });

    return sections;
  }

  List<BarChartGroupData> _buildHourlyBarGroups(
    Map<int, int> hourlyConsumption,
  ) {
    final List<BarChartGroupData> groups = [];

    hourlyConsumption.forEach((hour, amount) {
      groups.add(
        BarChartGroupData(
          x: hour,
          barRods: [
            BarChartRodData(
              toY: amount.toDouble(),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              width: 18,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    });

    return groups;
  }

  double _getMaxHourlyConsumption(Map<int, int> hourlyConsumption) {
    if (hourlyConsumption.isEmpty) return 500;
    final maxAmount = hourlyConsumption.values.reduce((a, b) => a > b ? a : b);
    return (maxAmount + 100).toDouble();
  }

  List<BarChartGroupData> _buildWeeklyBarGroups(
    List<Map<String, dynamic>> weekData,
    int goal,
  ) {
    final List<BarChartGroupData> groups = [];

    for (int i = 0; i < weekData.length; i++) {
      final amount = weekData[i]['amount'] as int;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: amount.toDouble(),
              gradient: LinearGradient(
                colors:
                    amount >= goal
                        ? [Colors.green[400]!, Colors.green[600]!]
                        : [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
              ),
              width: 22,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return groups;
  }

  double _getMaxWeeklyConsumption(
    List<Map<String, dynamic>> weekData,
    int goal,
  ) {
    if (weekData.isEmpty) return goal.toDouble() + 500;
    final maxAmount = weekData
        .map((day) => day['amount'] as int)
        .reduce((a, b) => a > b ? a : b);
    return math.max(maxAmount + 500, goal + 500).toDouble();
  }

  List<FlSpot> _buildMonthlySpots(List<Map<String, dynamic>> monthData) {
    final List<FlSpot> spots = [];

    for (int i = 0; i < monthData.length; i++) {
      spots.add(
        FlSpot(i.toDouble(), (monthData[i]['amount'] as int).toDouble()),
      );
    }

    return spots;
  }

  String _getBestDay(List<Map<String, dynamic>> monthData) {
    if (monthData.isEmpty || monthData.every((day) => day['amount'] == 0)) {
      return 'No data available';
    }

    int maxAmount = 0;
    int maxDay = 0;

    for (int i = 0; i < monthData.length; i++) {
      final amount = monthData[i]['amount'] as int;
      if (amount > maxAmount) {
        maxAmount = amount;
        maxDay = i + 1;
      }
    }

    final now = DateTime.now();
    final bestDay = DateTime(now.year, now.month, maxDay);
    return '${DateFormat('MMMM d').format(bestDay)} with $maxAmount ml';
  }

  String _getMostActiveTime(WaterProvider waterProvider) {
    final allDrinks = waterProvider.drinks;
    if (allDrinks.isEmpty) return 'No data available';

    final Map<int, int> hourlyCount = {};

    for (var drink in allDrinks) {
      final hour = drink.timestamp.hour;
      hourlyCount[hour] = (hourlyCount[hour] ?? 0) + 1;
    }

    int maxCount = 0;
    int maxHour = 0;

    hourlyCount.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        maxHour = hour;
      }
    });

    final period = maxHour < 12 ? 'AM' : 'PM';
    final displayHour =
        maxHour == 0 ? 12 : (maxHour > 12 ? maxHour - 12 : maxHour);

    return '$displayHour:00 $period with $maxCount drinks';
  }

  String _getLongestStreak(List<Map<String, dynamic>> monthData, int goal) {
    if (monthData.isEmpty) return 'No data available';

    int currentStreak = 0;
    int maxStreak = 0;

    for (var day in monthData) {
      final amount = day['amount'] as int;
      if (amount >= goal) {
        currentStreak++;
        maxStreak = math.max(maxStreak, currentStreak);
      } else {
        currentStreak = 0;
      }
    }

    return '$maxStreak days in a row';
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
