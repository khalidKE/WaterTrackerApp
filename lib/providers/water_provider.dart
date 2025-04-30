import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:water_tracker/models/drink.dart';

class WaterProvider with ChangeNotifier {
  List<Drink> _drinks = [];
  int _dailyGoal = 2000; // Default goal in ml
  bool _remindersEnabled = false;
  String _unit = 'ml'; // 'ml' or 'oz'

  WaterProvider() {
    _loadData();
  }

  // Getters
  List<Drink> get drinks => _drinks;
  int get dailyGoal => _dailyGoal;
  bool get remindersEnabled => _remindersEnabled;
  String get unit => _unit;

  // Methods
  void addDrink(Drink drink) {
    _drinks.add(drink);
    _saveData();
    notifyListeners();
  }

  void removeDrink(int index) {
    _drinks.removeAt(index);
    _saveData();
    notifyListeners();
  }

  void setDailyGoal(int goal) {
    _dailyGoal = goal;
    _saveData();
    notifyListeners();
  }

  void setRemindersEnabled(bool enabled) {
    _remindersEnabled = enabled;
    _saveData();
    notifyListeners();
  }

  void setUnit(String unit) {
    _unit = unit;
    _saveData();
    notifyListeners();
  }

  // Helper methods
  List<Drink> getTodayDrinks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _drinks.where((drink) {
      final drinkDate = DateTime(
        drink.timestamp.year,
        drink.timestamp.month,
        drink.timestamp.day,
      );
      return drinkDate.isAtSameMomentAs(today);
    }).toList();
  }

  int getTodayTotal() {
    final todayDrinks = getTodayDrinks();
    return todayDrinks.fold(0, (sum, drink) => sum + drink.amount);
  }

  double getTodayProgress() {
    return getTodayTotal() / _dailyGoal;
  }

  // Get weekly data for charts
  List<Map<String, dynamic>> getWeeklyData() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekData = [];

    // If we don't have real data, generate some sample data
    if (_drinks.isEmpty) {
      return _generateSampleWeekData();
    }

    // Get the start of the week (Monday)
    final int currentWeekday = now.weekday;
    final startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    // Create data for each day of the week
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayDrinks = _getDrinksForDate(day);
      final amount = dayDrinks.fold(0, (sum, drink) => sum + drink.amount);

      weekData.add({
        'day': _getWeekdayName(day.weekday),
        'amount': amount,
        'goal': _dailyGoal,
      });
    }

    return weekData;
  }

  // Get monthly data for charts
  List<Map<String, dynamic>> getMonthlyData() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> monthData = [];

    // If we don't have real data, generate some sample data
    if (_drinks.isEmpty) {
      return _generateSampleMonthData();
    }

    // Get the number of days in the current month
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // Create data for each day of the month
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(now.year, now.month, i);
      final dayDrinks = _getDrinksForDate(day);
      final amount = dayDrinks.fold(0, (sum, drink) => sum + drink.amount);

      monthData.add({'day': i, 'amount': amount, 'goal': _dailyGoal});
    }

    return monthData;
  }

  // Helper method to get drinks for a specific date
  List<Drink> _getDrinksForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);

    return _drinks.where((drink) {
      final drinkDate = DateTime(
        drink.timestamp.year,
        drink.timestamp.month,
        drink.timestamp.day,
      );
      return drinkDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // Helper method to get weekday name
  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Generate sample weekly data for demonstration
  List<Map<String, dynamic>> _generateSampleWeekData() {
    final random = math.Random();
    final List<Map<String, dynamic>> weekData = [];

    for (int i = 0; i < 7; i++) {
      // Generate random amount between 1500 and 2500
      final amount = 1500 + random.nextInt(1000);

      weekData.add({
        'day': _getWeekdayName(i + 1),
        'amount': amount,
        'goal': _dailyGoal,
      });
    }

    return weekData;
  }

  // Generate sample monthly data for demonstration
  List<Map<String, dynamic>> _generateSampleMonthData() {
    final random = math.Random();
    final List<Map<String, dynamic>> monthData = [];
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      // Generate random amount between 1500 and 2500
      final amount = 1500 + random.nextInt(1000);

      monthData.add({'day': i, 'amount': amount, 'goal': _dailyGoal});
    }

    return monthData;
  }

  // Data persistence
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
    _unit = prefs.getString('unit') ?? 'ml';

    final drinksJson = prefs.getStringList('drinks') ?? [];
    _drinks =
        drinksJson.map((json) => Drink.fromJson(jsonDecode(json))).toList();

    // If no drinks data, generate some sample data
    if (_drinks.isEmpty) {
      _generateSampleDrinks();
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('dailyGoal', _dailyGoal);
    await prefs.setBool('remindersEnabled', _remindersEnabled);
    await prefs.setString('unit', _unit);

    final drinksJson =
        _drinks.map((drink) => jsonEncode(drink.toJson())).toList();
    await prefs.setStringList('drinks', drinksJson);
  }

  // Generate sample drinks data for demonstration
  void _generateSampleDrinks() {
    final random = math.Random();
    final now = DateTime.now();

    // Generate drinks for the past 30 days
    for (int day = 0; day < 30; day++) {
      final date = now.subtract(Duration(days: day));

      // Generate 3-8 drinks per day
      final drinksCount = 3 + random.nextInt(6);

      for (int i = 0; i < drinksCount; i++) {
        // Random hour between 8 and 22
        final hour = 8 + random.nextInt(14);
        final minute = random.nextInt(60);

        final timestamp = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // Random drink type
        final drinkType =
            DrinkType.values[random.nextInt(DrinkType.values.length)];

        // Random amount between 100 and 500
        final amount = (1 + random.nextInt(5)) * 100;

        _drinks.add(
          Drink(type: drinkType, amount: amount, timestamp: timestamp),
        );
      }
    }
  }
}
