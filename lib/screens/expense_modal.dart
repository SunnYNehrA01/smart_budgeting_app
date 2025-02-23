import 'package:flutter/material.dart';

class Expense {
  final String category;
  final double amount;
  final DateTime date;
  final String note;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });
}

class ExpenseModel extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(String category, double amount, DateTime date, String note) {
    final expense = Expense(
      category: category,
      amount: amount,
      date: date,
      note: note,
    );

    _expenses.add(expense);
    notifyListeners(); // Notify UI about the change
  }
}
