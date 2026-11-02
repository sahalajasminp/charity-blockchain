import 'package:flutter/material.dart';
import 'package:handsofhope/view%20charity.dart';
import 'package:handsofhope/view_contractors.dart';

import 'complaints.dart';
import 'feedback.dart';
import 'handicapped/manage_products.dart';
import 'others_products.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcome charity'),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewContractors()));
          }, child: Text('Contractors')),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageProduct()));
          }, child: Text('My Products')),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewOthersProductsPage()));
          }, child: Text('Others Products')),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewcharity_details()));
          }, child: Text('Charity details')),
        ],
      ),
    );
  }
}
