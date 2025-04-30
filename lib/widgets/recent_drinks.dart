import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/drink.dart';


class RecentDrinks extends StatelessWidget {
  final List<Drink> drinks;
  
  const RecentDrinks({
    super.key,
    required this.drinks,
  });

  @override
  Widget build(BuildContext context) {
    if (drinks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text('No drinks added today'),
                const SizedBox(height: 8),
                const Text(
                  'Tap the + button to add your first drink',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: drinks.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final drink = drinks[index];
          return ListTile(
            leading: _getIconForDrinkType(drink.type),
            title: Text(_getDrinkTypeString(drink.type)),
            subtitle: Text(DateFormat('HH:mm').format(drink.timestamp)),
            trailing: Text(
              '${drink.amount} ml',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _getIconForDrinkType(DrinkType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case DrinkType.water:
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case DrinkType.coffee:
        icon = Icons.coffee;
        color = Colors.brown;
        break;
      case DrinkType.tea:
        icon = Icons.emoji_food_beverage;
        color = Colors.green;
        break;
      case DrinkType.juice:
        icon = Icons.local_drink;
        color = Colors.orange;
        break;
    }
    
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color),
    );
  }
  
  String _getDrinkTypeString(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return 'Water';
      case DrinkType.coffee:
        return 'Coffee';
      case DrinkType.tea:
        return 'Tea';
      case DrinkType.juice:
        return 'Juice';
    }
  }
}
