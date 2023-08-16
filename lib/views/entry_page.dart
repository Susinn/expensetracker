import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseEntryPage extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  const ExpenseEntryPage(this.onExpenseAdded, {super.key});

  @override
  ExpenseEntryPageState createState() => ExpenseEntryPageState();
}

class ExpenseEntryPageState extends State<ExpenseEntryPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitExpense() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    final expense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    widget.onExpenseAdded(expense);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
