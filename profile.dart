import 'package:flutter/material.dart';

class HandicappedProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const HandicappedProfilePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(data['photo']),
            ),
            const SizedBox(height: 12),
            Text(data['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(data['email'], style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("Phone", data['phone'].toString()),
                    _buildInfoRow("Age", data['age'].toString()),
                    _buildInfoRow("Gender", data['gender']),
                    _buildInfoRow("Place", data['place']),
                    _buildInfoRow("District", data['district']),
                    _buildInfoRow("Pincode", data['pincode']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("ID Proof", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Card(
              child: Image.network(data['idproof'], height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),


          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
