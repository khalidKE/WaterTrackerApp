import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/drink.dart';

class WaterProvider extends ChangeNotifier {
  List<Drink> _drinks = [];
  int _dailyGoal = 2000; // Default goal in ml
  bool _remindersEnabled = true;
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
  
  // Data persistence
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
    _unit = prefs.getString('unit') ?? 'ml';
    
    final drinksJson = prefs.getStringList('drinks') ?? [];
    _drinks = drinksJson.map((json) => Drink.fromJson(jsonDecode(json))).toList();
    
    notifyListeners();
  }
  
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('dailyGoal', _dailyGoal);
    await prefs.setBool('remindersEnabled', _remindersEnabled);
    await prefs.setString('unit', _unit);
    
    final drinksJson = _drinks.map((drink) => jsonEncode(drink.toJson())).toList();
    await prefs.setStringList('drinks', drinksJson);
  }
}
