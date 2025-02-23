import 'package:flutter/material.dart';

class InvestmentAdviceScreen extends StatelessWidget {
  const InvestmentAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Investment Advice")),
      body: const Center(child: Text("Investment Advice Screen")),
    );
  }
}
