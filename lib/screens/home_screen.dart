import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // ✅ Fixed warning by using super.key

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double weeklyGoal = 5000;
  double monthlyGoal = 20000;
  double weeklyExpense = 2500;
  double monthlyExpense = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildProgressBar(
                      'Weekly Budget',
                      weeklyExpense,
                      weeklyGoal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProgressBar(
                      'Monthly Budget',
                      monthlyExpense,
                      monthlyGoal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String title, double expense, double goal) {
    double percentage = (expense / goal).clamp(0.0, 1.0);
    Color progressColor = expense >= goal ? Colors.red : Colors.green;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: percentage,
          center: Text("${(percentage * 100).toStringAsFixed(1)}%"),
          progressColor: progressColor,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 10),
        Text("Goal: ₹${goal.toStringAsFixed(2)}"),
        Text("Expense: ₹${expense.toStringAsFixed(2)}"),
      ],
    );
  }
}
