import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/providers/water_provider.dart';
import 'package:water_tracker/screens/profile_screen.dart';

class WaterGoalCalculator extends StatefulWidget {
  const WaterGoalCalculator({super.key});

  @override
  _WaterGoalCalculatorState createState() => _WaterGoalCalculatorState();
}

class _WaterGoalCalculatorState extends State<WaterGoalCalculator> {
  final TextEditingController _weightController = TextEditingController(
    text: '70',
  );
  final TextEditingController _heightController = TextEditingController(
    text: '170',
  );
  final TextEditingController _manualGoalController = TextEditingController();

  String _gender = 'male';
  String _activityLevel = 'moderate';
  bool _isManualGoal = false;
  int _calculatedGoal = 0;

  // Saved state
  String? _savedGender;
  String? _savedActivityLevel;
  String? _savedWeight;
  String? _savedHeight;
  String? _savedManualGoal;
  bool? _savedIsManualGoal;

  @override
  void initState() {
    super.initState();
    _calculateGoal();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _manualGoalController.dispose();
    super.dispose();
  }

  void _calculateGoal() {
    // Use fallback values for invalid or empty inputs
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final height = double.tryParse(_heightController.text) ?? 170.0;

    double factor = 30;

    if (_gender == 'female') {
      factor -= 2;
    }

    switch (_activityLevel) {
      case 'sedentary':
        factor -= 5;
        break;
      case 'moderate':
        break;
      case 'active':
        factor += 5;
        break;
      case 'very_active':
        factor += 10;
        break;
    }

    // Adjust factor based on height
    if (height > 170) {
      factor += (height - 170) * 0.05;
    } else {
      factor -= (170 - height) * 0.05;
    }

    setState(() {
      _calculatedGoal = (weight * factor).round();
      if (!_isManualGoal) {
        _manualGoalController.text = _calculatedGoal.toString();
      }
    });
  }

  void _saveForm() {
    setState(() {
      _savedGender = _gender;
      _savedActivityLevel = _activityLevel;
      _savedWeight = _weightController.text;
      _savedHeight = _heightController.text;
      _savedManualGoal = _manualGoalController.text;
      _savedIsManualGoal = _isManualGoal;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(' Saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    const fontSizeTitle = 20.0;
    const fontSizeSubtitle = 16.0;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: const Color(0xFF5AC8FA),
          secondary: const Color(0xFF1E3A8A),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 700),
              child: Text(
                'Calculate Your Water Intake Goal',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gender selection
            FadeInDown(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Gender',
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children:
                  ['male', 'female'].map((gender) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          gender[0].toUpperCase() + gender.substring(1),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: gender,
                        groupValue: _gender,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _gender = value;
                              _calculateGoal();
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Activity level selection
            FadeInDown(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 150),
              child: Text(
                'Activity Level',
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              decoration: InputDecoration(
                hintText: 'Select activity level',
                prefixIcon: Icon(
                  Icons.directions_run,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
                DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(
                  value: 'very_active',
                  child: Text('Very Active'),
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
            const SizedBox(height: 16),

            // Weight
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Weight',
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 250),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _calculateGoal();
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your weight',
                        prefixIcon: Icon(
                          Icons.monitor_weight,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        errorText:
                            _weightController.text.isEmpty ||
                                    (double.tryParse(_weightController.text) ==
                                            null ||
                                        double.parse(_weightController.text) <=
                                            0)
                                ? 'Enter a valid weight'
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'kg',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Height
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Height',
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 350),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _calculateGoal();
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your height',
                        prefixIcon: Icon(
                          Icons.height,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        errorText:
                            _heightController.text.isEmpty ||
                                    (double.tryParse(_heightController.text) ==
                                            null ||
                                        double.parse(_heightController.text) <=
                                            0)
                                ? 'Enter a valid height'
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'cm',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Manual override
            Row(
              children: [
                Checkbox(
                  value: _isManualGoal,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isManualGoal = value;
                        if (!_isManualGoal) {
                          _manualGoalController.text =
                              _calculatedGoal.toString();
                        }
                      });
                    }
                  },
                ),
                Text(
                  'Set goal manually',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Recommended Daily Goal: $_calculatedGoal ml',
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _manualGoalController,
              enabled: _isManualGoal,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Water Goal (ml)',
                errorText:
                    _isManualGoal &&
                            (_manualGoalController.text.isEmpty ||
                                int.tryParse(_manualGoalController.text) ==
                                    null ||
                                int.parse(_manualGoalController.text) <= 0)
                        ? 'Enter a valid goal'
                        : null,
              ),
            ),
            const SizedBox(height: 24),

            // Save and Cancel buttons
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_weightController.text.isEmpty ||
                          double.tryParse(_weightController.text) == null ||
                          double.parse(_weightController.text) <= 0 ||
                          _heightController.text.isEmpty ||
                          double.tryParse(_heightController.text) == null ||
                          double.parse(_heightController.text) <= 0 ||
                          (_isManualGoal &&
                              (_manualGoalController.text.isEmpty ||
                                  int.tryParse(_manualGoalController.text) ==
                                      null ||
                                  int.parse(_manualGoalController.text) <=
                                      0))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter valid inputs'),
                          ),
                        );
                        return;
                      }

                      final int goal =
                          _isManualGoal
                              ? int.tryParse(_manualGoalController.text) ??
                                  _calculatedGoal
                              : _calculatedGoal;

                      try {
                        Provider.of<WaterProvider>(
                          context,
                          listen: false,
                        ).setDailyGoal(goal);
                        _saveForm();
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error saving goal')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
