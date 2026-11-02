import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddQuantityPage extends StatefulWidget {
  const AddQuantityPage({super.key});

  @override
  State<AddQuantityPage> createState() => _AddQuantityPageState();
}

class _AddQuantityPageState extends State<AddQuantityPage> {
  final TextEditingController quantityController = TextEditingController();

  Future<void> sendQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("url") ?? "";

    if (quantityController.text.isEmpty) {
      showMessage("Please enter quantity");
      return;
    }

    final response = await http.post(
      Uri.parse("$ip/UserAddQuantity/"),   // <-- Updated API URL
      body: {
        'quantity': quantityController.text,   // <-- Updated field
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      showMessage("Quantity Added Successfully!");
      quantityController.clear();
    } else {
      showMessage("Failed to add quantity");
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
      appBar: AppBar(title: const Text("Add Quantity")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Quantity", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Quantity',
              ),
            ),

            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: sendQuantity,
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
