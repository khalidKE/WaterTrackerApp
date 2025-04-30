import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drink.dart';
import '../providers/water_provider.dart';


class AddWaterDialog extends StatefulWidget {
  const AddWaterDialog({super.key});

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  int _amount = 250;
  DrinkType _selectedType = DrinkType.water;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Drink'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drink type selection
          const Text('Select Drink Type'),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDrinkTypeChip(DrinkType.water, 'Water', Icons.water_drop),
                _buildDrinkTypeChip(DrinkType.coffee, 'Coffee', Icons.coffee),
                _buildDrinkTypeChip(DrinkType.tea, 'Tea', Icons.emoji_food_beverage),
                _buildDrinkTypeChip(DrinkType.juice, 'Juice', Icons.local_drink),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Amount selection
          const Text('Amount (ml)'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_amount > 50) {
                      _amount -= 50;
                    }
                  });
                },
              ),
              Text(
                '$_amount ml',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _amount += 50;
                  });
                },
              ),
            ],
          ),
          Slider(
            value: _amount.toDouble(),
            min: 50,
            max: 1000,
            divisions: 19,
            label: '$_amount ml',
            onChanged: (value) {
              setState(() {
                _amount = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final drink = Drink(
              type: _selectedType,
              amount: _amount,
              timestamp: DateTime.now(),
            );
            
            Provider.of<WaterProvider>(context, listen: false).addDrink(drink);
            
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
  
  Widget _buildDrinkTypeChip(DrinkType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        avatar: Icon(
          icon,
          color: isSelected ? Colors.white : null,
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedType = type;
            });
          }
        },
      ),
    );
  }
}
