import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'add amount.dart';

class Viewcharity_details extends StatefulWidget {
  const Viewcharity_details({super.key});

  @override
  State<Viewcharity_details> createState() => _Viewcharity_detailsState();
}

class _Viewcharity_detailsState extends State<Viewcharity_details> {
  late Future<List<Map<String, dynamic>>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";

    final response = await http.post(Uri.parse("$ip/UserViewcharity_details/"));
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      return [];
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _futureUsers = fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View All Charity Details")),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No charity details found"));
            }

            final users = snapshot.data!;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      user['name'] ?? "No Name",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NGO Name: ${user['ngoname']}"),
                        Text("Phone: ${user['phone']}"),
                        Text("Details: ${user['details']}"),
                        Text("Email: ${user['ongo_email']}"),
                        Text("Licence: ${user['licence']}"),
                        Text("Amount: ${user['amount']}"),
                        Text("Place: ${user['place']}"),
                        Text("Date: ${user['date']}"),


                        ElevatedButton(onPressed: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAmountPage()));

                        }, child: Text("Donate Amount"))
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
