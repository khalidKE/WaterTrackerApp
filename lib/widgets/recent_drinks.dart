import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/widgets/add_water_dialog.dart';
import '../models/drink.dart';

class RecentDrinks extends StatelessWidget {
  final List<Drink> drinks;

  const RecentDrinks({super.key, required this.drinks});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (drinks.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color:
            isDarkMode
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                Image.asset('images/small_glass.png', height: 80),
                const SizedBox(height: 16),
                const Text(
                  'No drinks added today',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first drink',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddWaterDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add First Drink'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color:
          isDarkMode
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.primary.withOpacity(0.05),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: drinks.length > 3 ? 3 : drinks.length,
        separatorBuilder: (context, index) => const Divider(indent: 70),
        itemBuilder: (context, index) {
          final drink = drinks[index];
          return ListTile(
            leading: _getIconForDrinkType(drink.type),
            title: Text(
              _getDrinkTypeString(drink.type),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(DateFormat('HH:mm').format(drink.timestamp)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${drink.amount} ml',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
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

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
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
