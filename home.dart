// import 'package:flutter/material.dart';
// import 'package:handsofhope/handicapped/manage_products.dart';
// import 'package:handsofhope/handicapped/send%20charity%20request.dart';
// import 'package:handsofhope/handicapped/view%20charity.dart';
// import 'package:handsofhope/login.dart';
// import 'package:handsofhope/view%20charity.dart';
// import 'package:handsofhope/view_contractors.dart';
//
//
// class HandHome extends StatefulWidget {
//   const HandHome({super.key});
//
//   @override
//   State<HandHome> createState() => _HandHomeState();
// }
//
// class _HandHomeState extends State<HandHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('welcome charity'),),
//       body: Column(
//         children: [
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewContractors()));
//           }, child: Text('Contractors')),
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageProduct()));
//           }, child: Text('My Products')),
//
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>CharityPage()));
//           }, child: Text('Send Charity')),
//
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewCharityDetails()));
//           }, child: Text('Charity details')),
//
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewCharityDetails()));
//           }, child: Text('View Orders')),
//
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewCharityDetails()));
//           }, child: Text('View Payment Status')),
//
//           ElevatedButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
//           }, child: Text('Logout')),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handsofhope/handicapped/manage_products.dart';
import 'package:handsofhope/handicapped/profile.dart';
import 'package:handsofhope/handicapped/send%20charity%20request.dart';
import 'package:handsofhope/handicapped/view%20charity.dart';
import 'package:handsofhope/handicapped/view%20other%20products.dart';
import 'package:handsofhope/login.dart';
import 'package:handsofhope/view%20charity.dart';
import 'package:handsofhope/view_contractors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class HandHome extends StatefulWidget {
  const HandHome({super.key});

  @override
  State<HandHome> createState() => _HandHomeState();
}

class _HandHomeState extends State<HandHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Hands of Hope',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Charity Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Main Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildMenuCard(
                        context,
                        icon: Icons.person,
                        title: 'Profile',
                        subtitle: 'View Profile',
                        color: Colors.orange,
                        onTap: () async {
                          try {
                            final prefs = await SharedPreferences.getInstance();
                            String? userLoginId = prefs.getString('lid');

                            if (userLoginId == null) {
                              throw Exception("Login ID not found. Please log in again.");
                            }

                            final profileData = await fetchProfile(userLoginId);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HandicappedProfilePage(data: profileData),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error fetching profile: $e")),
                            );
                          }
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.inventory_2,
                        title: 'My Products',
                        subtitle: 'Manage',
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageProduct(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.volunteer_activism,
                        title: 'Send Charity',
                        subtitle: 'Request',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharityPage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.description,
                        title: 'Charity Details',
                        subtitle: 'View info',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCharityDetails(),
                          ),
                        ),
                      ),


                      _buildMenuCard(
                        context,
                        icon: Icons.description,
                        title: 'Other Products',
                        subtitle: 'View Products',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HandicappedViewOthersProductsPage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.shopping_bag,
                        title: 'View Orders',
                        subtitle: 'Track',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCharityDetails(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.payment,
                        title: 'Payment Status',
                        subtitle: 'Check',
                        color: Colors.indigo,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCharityDetails(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchProfile(String lid) async {
  final pref = await SharedPreferences.getInstance();

  final ip = pref.getString('url') ?? "";

  final response = await http.post(

    Uri.parse("$ip/person_view_profile/"),

    body: {'lid': lid},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'ok') {
      return data;
    } else {
      throw Exception(data['message']);
    }
  } else {
    throw Exception("Failed to load profile");
  }
}
