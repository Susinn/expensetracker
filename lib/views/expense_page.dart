import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';
import 'entry_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  List<Expense> expenses = [];
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? expenseStrings = prefs.getStringList('expenses');

    if (expenseStrings != null) {
      setState(() {
        expenses = expenseStrings.map((e) => Expense.fromJson(e)).toList();
        calculateTotalExpense();
      });
    }
  }

  Future<void> saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> expenseStrings = expenses.map((e) => e.toJson()).toList();
    await prefs.setStringList('expenses', expenseStrings);
  }

  void calculateTotalExpense() {
    totalExpense =
        expenses.fold(0.0, (previous, current) => previous + current.amount);
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      calculateTotalExpense();
    });
    saveExpenses();
  }

  void deleteExpense(int index) {
    final deletedExpense = expenses[index];
    final deletedExpenseIndex = index;
    setState(() {
      expenses.removeAt(index);
      calculateTotalExpense();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              if (deletedExpenseIndex >= 0) {
                setState(() {
                  expenses.insert(deletedExpenseIndex, deletedExpense);
                  calculateTotalExpense();
                });
                saveExpenses();
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Expenses Tracker'),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Total : \$${totalExpense.toString()}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final formatedDate = DateFormat.yMMMMd().format(expenses[index].date);
          return Column(
            children: [
              Dismissible(
                key: Key(expenses[index].hashCode.toString()),
                onDismissed: (direction) {
                  deleteExpense(index);
                },
                child: ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(
                    expenses[index].title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(formatedDate.toString()),
                  trailing: Text(
                    '\$${expenses[index].amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpenseEntryPage(addExpense)),
          );
        },
      ),
    );
  }
}
