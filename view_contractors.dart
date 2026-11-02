import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewContractors extends StatefulWidget {
  const ViewContractors({super.key});

  @override
  State<ViewContractors> createState() => _ViewContractorsState();
}

class _ViewContractorsState extends State<ViewContractors> {
  late Future<List<Map<String, dynamic>>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final imgUrl = pref.getString('img_url') ?? "";

    final response = await http.post(Uri.parse("$ip/UserViewContractors/"));
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      // Attach full image URL to each user
      return List<Map<String, dynamic>>.from(jsonData['data']).map((user) {
        user['photo'] = user['photo'] != null ? imgUrl + user['photo'] : null;
        return user;
      }).toList();
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
      appBar: AppBar(title: const Text("View All Contractors")),
      body: RefreshIndicator(
        onRefresh: _refreshUsers, // ✅ Pull to refresh
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No contractors found"));
            }

            final users = snapshot.data!;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(

                    title: Text(
                      user['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                        children: [
                          Text('name'+user['name']),
                          Text('Email'+user['email']),
                          Text('Place'+user['place']),
                          Text('phone'+user['phone']),
                          Text('latitude'+user['latitude']),
                          Text('longitude'+user['longitude']),

                        ],
                    )
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
