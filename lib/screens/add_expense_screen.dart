import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food'; // Default category
  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Bills', 'Shopping', 'Others'];

  final List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _descriptionController.text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _addExpense() {
    if (_amountController.text.isEmpty || _descriptionController.text.isEmpty) return;

    setState(() {
      _expenses.add({
        'date': _selectedDate,
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
      });
    });

    _amountController.clear();
    _descriptionController.clear();
    Navigator.pop(context); // Close the dialog
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental closing
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Expense"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Amount"),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList()
                    ..add(
                      const DropdownMenuItem(
                        value: 'Custom',
                        child: Text("Add Custom Category"),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == 'Custom') {
                        _showCustomCategoryDialog(setDialogState);
                      } else {
                        setDialogState(() {
                          _selectedCategory = value!;
                        });
                      }
                    },
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showCustomCategoryDialog(StateSetter parentSetState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Custom Category"),
          content: TextField(
            controller: _customCategoryController,
            decoration: const InputDecoration(labelText: "Category Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _categories.add(_customCategoryController.text);
                  _selectedCategory = _customCategoryController.text;
                });
                parentSetState(() {}); // Update dropdown in the main dialog
                _customCategoryController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Expenses"),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Text(
                DateFormat.yMMMMd().format(_selectedDate),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Category")),
                  DataColumn(label: Text("Amount")),
                  DataColumn(label: Text("Description")),
                ],
                rows: _expenses
                    .where((expense) =>
                        DateFormat.yMd().format(expense['date']) == DateFormat.yMd().format(_selectedDate))
                    .map((expense) {
                  return DataRow(cells: [
                    DataCell(Text(expense['category'])),
                    DataCell(Text("₹${expense['amount'].toStringAsFixed(2)}")),
                    DataCell(Text(expense['description'])),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExpenseDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
