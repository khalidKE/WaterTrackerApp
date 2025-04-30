import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';

class GoalCalculator extends StatefulWidget {
  const GoalCalculator({super.key});

  @override
  State<GoalCalculator> createState() => _GoalCalculatorState();
}

class _GoalCalculatorState extends State<GoalCalculator> {
  final _weightController = TextEditingController(text: '70');
  String _gender = 'male';
  String _activityLevel = 'moderate';
  int _calculatedGoal = 2000;
  bool _isManualGoal = false;
  final _manualGoalController = TextEditingController(text: '2000');
  
  @override
  void initState() {
    super.initState();
    _calculateGoal();
  }
  
  @override
  void dispose() {
    _weightController.dispose();
    _manualGoalController.dispose();
    super.dispose();
  }
  
  void _calculateGoal() {
    final weight = double.tryParse(_weightController.text) ?? 70;
    
    // Basic formula: weight in kg * factor
    // Factor depends on gender and activity level
    double factor = 30;
    
    if (_gender == 'female') {
      factor -= 2;
    }
    
    switch (_activityLevel) {
      case 'sedentary':
        factor -= 5;
        break;
      case 'moderate':
        // Default
        break;
      case 'active':
        factor += 5;
        break;
      case 'very_active':
        factor += 10;
        break;
    }
    
    setState(() {
      _calculatedGoal = (weight * factor).round();
      if (!_isManualGoal) {
        _manualGoalController.text = _calculatedGoal.toString();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculate Daily Water Goal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Weight input
          Text(
            'Weight',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your weight',
                  ),
                  onChanged: (_) => _calculateGoal(),
                ),
              ),
              const SizedBox(width: 16),
              const Text('kg'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Gender selection
          Text(
            'Gender',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'male',
                label: Text('Male'),
                icon: Icon(Icons.male),
              ),
              ButtonSegment(
                value: 'female',
                label: Text('Female'),
                icon: Icon(Icons.female),
              ),
            ],
            selected: {_gender},
            onSelectionChanged: (selection) {
              setState(() {
                _gender = selection.first;
                _calculateGoal();
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Activity level
          Text(
            'Activity Level',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _activityLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'sedentary',
                child: Text('Sedentary (little or no exercise)'),
              ),
              DropdownMenuItem(
                value: 'moderate',
                child: Text('Moderate (light exercise 1-3 days/week)'),
              ),
              DropdownMenuItem(
                value: 'active',
                child: Text('Active (moderate exercise 3-5 days/week)'),
              ),
              DropdownMenuItem(
                value: 'very_active',
                child: Text('Very Active (hard exercise 6-7 days/week)'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _activityLevel = value;
                  _calculateGoal();
                });
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Calculated goal
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Daily Goal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_calculatedGoal ml',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Manual goal setting
          Row(
            children: [
              Checkbox(
                value: _isManualGoal,
                onChanged: (value) {
                  setState(() {
                    _isManualGoal = value ?? false;
                  });
                },
              ),
              const Text('Set custom goal'),
            ],
          ),
          
          if (_isManualGoal) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manualGoalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter custom goal',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('ml'),
              ],
            ),
          ],
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  final goal = _isManualGoal
                      ? int.tryParse(_manualGoalController.text) ?? _calculatedGoal
                      : _calculatedGoal;
                  
                  Provider.of<WaterProvider>(context, listen: false).setDailyGoal(goal);
                  
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
