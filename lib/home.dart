import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> expenses = [];
  bool isBold = false;

  Future<void> _addExpense(String expense) async {
    final apiUrl = Uri.parse('https://encouraging-till.000webhostapp.com/add_expense.php');

    try {
      final response = await http.post(
        apiUrl,
        body: {'expense': expense},
      );

      if (response.statusCode == 200) {
        setState(() {
          expenses.add(expense);
        });
      } else {
        print('Failed to add expense. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding expense: $error');
    }
  }

  void _openAddExpenseDialog() async {
    String enteredText = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String text = '';
        return AlertDialog(
          title: const Text('Add Expense'),
          content: TextField(
            onChanged: (value) {
              text = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your expense',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(text);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (enteredText != null && enteredText.isNotEmpty) {
      await _addExpense(enteredText);
    }
  }

  void _clearAllExpenses() {
    setState(() {
      expenses.clear();
    });
  }

  void _changeTextStyle(bool isBoldText) {
    setState(() {
      isBold = isBoldText;
    });
  }

  Future<void> _showAllExpenses(BuildContext context) async {
    final apiUrl = Uri.parse('https://encouraging-till.000webhostapp.com/get_expenses.php');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          expenses = List<String>.from(json.decode(response.body));
        });
      } else {
        print('Failed to fetch expenses. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching expenses: $error');
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllExpensesPage(expenses: expenses)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        actions: [
          IconButton(
            onPressed: () => _showAllExpenses(context),
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      expenses[index],
                      style: TextStyle(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: false,
                      groupValue: isBold,
                      onChanged: (bool? value) {
                        _changeTextStyle(value ?? false);
                      },
                    ),
                    const Text('Normal'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: true,
                      groupValue: isBold,
                      onChanged: (bool? value) {
                        _changeTextStyle(value ?? false);
                      },
                    ),
                    const Text('Bold'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _openAddExpenseDialog,
                  child: const Text('Add Expense'),
                ),
                ElevatedButton(
                  onPressed: _clearAllExpenses,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AllExpensesPage extends StatefulWidget {
  final List<String> expenses;

  const AllExpensesPage({Key? key, required this.expenses}) : super(key: key);

  @override
  _AllExpensesPageState createState() => _AllExpensesPageState();
}

class _AllExpensesPageState extends State<AllExpensesPage> {
  late List<String> expenses;

  @override
  void initState() {
    super.initState();
    expenses = widget.expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Expenses'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(expenses[index]),
          );
        },
      ),
    );
  }
}
