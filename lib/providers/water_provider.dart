import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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

  // Data persistence
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _remindersEnabled = prefs.getBool('remindersEnabled') ?? false;
    _unit = prefs.getString('unit') ?? 'ml';

    final drinksJson = prefs.getStringList('drinks') ?? [];
    _drinks =
        drinksJson.map((json) => Drink.fromJson(jsonDecode(json))).toList();

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
}
