import 'dart:convert';

class Expense {
  final String title;
  final double amount;
  final DateTime date;

  Expense({required this.title, required this.amount, required this.date});

  factory Expense.fromJson(String jsonString) {
    Map<String, dynamic> json = Map<String, dynamic>.from(
      jsonDecode(jsonString),
    );

    return Expense(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  String toJson() {
    Map<String, dynamic> json = {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };

    return jsonEncode(json);
  }
}
