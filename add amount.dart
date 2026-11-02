import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddAmountPage extends StatefulWidget {
  const AddAmountPage({super.key});

  @override
  State<AddAmountPage> createState() => _AddAmountPageState();
}

class _AddAmountPageState extends State<AddAmountPage> {
  final TextEditingController amountController = TextEditingController();

  Future<void> sendAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("url") ?? "";

    if (amountController.text.isEmpty) {
      showMessage("Please enter amount");
      return;
    }

    final response = await http.post(
      Uri.parse("$ip/UserAddAmount/"),
      body: {
        'amount': amountController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      showMessage("Amount Added Successfully!");
      amountController.clear();
    } else {
      showMessage("Failed to add amount");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Amount")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Amount", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Amount',
              ),
            ),

            const SizedBox(height: 20),



            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: sendAmount,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
