import 'package:flutter/material.dart';

class BudgetPlannerScreen extends StatelessWidget {
  const BudgetPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Planner")),
      body: const Center(child: Text("Budget Planner Screen")),
    );
  }
}
