import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllExpensesPage extends StatefulWidget {
  @override
  _AllExpensesPageState createState() => _AllExpensesPageState();
}

class _AllExpensesPageState extends State<AllExpensesPage> {
  List<String> expenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
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
