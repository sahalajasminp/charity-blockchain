import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../add product.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  late Future<List<Map<String, dynamic>>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final pref = await SharedPreferences.getInstance();
    final String? ip = pref.getString('url');
    final String? imgurl = pref.getString('img_url');
    final String? lid = pref.getString('lid');

    if (ip == null || imgurl == null || lid == null) return [];

    try {
      final response = await http.post(
        Uri.parse("$ip/ManageProduct/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          return (jsonData['data'] as List).map((product) {
            String rawImage = product['image'].toString();
            String imageUrl = rawImage;

            if (!rawImage.startsWith('http')) {
              String base = imgurl.endsWith('/') ? imgurl.substring(0, imgurl.length - 1) : imgurl;
              String path = rawImage.startsWith('/') ? rawImage : '/$rawImage';
              imageUrl = base + path;
            }

            return {
              'id': product['id'].toString(),
              'productname': product['productname'] ?? 'Unnamed Product',
              'image': imageUrl,
              'price': product['price']?.toString() ?? '0',
              'stock': product['stock']?.toString() ?? '0',
              'details': product['details'] ?? 'No description',
            };
          }).toList();
        }
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
    return [];
  }

  // Update Stock Dialog - Beautiful Orange Style
  void showUpdateStockDialog(String pid, String currentStock, String name) {
    final controller = TextEditingController(text: currentStock);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.inventory_2, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Text("Update Stock", style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "New Stock Quantity",
              prefixIcon: const Icon(Icons.numbers, color: Colors.orange),
              filled: true,
              fillColor: Colors.orange.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Required";
              if (int.tryParse(v) == null || int.parse(v) < 0) return "Enter valid number";
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final pref = await SharedPreferences.getInstance();
              final String? ip = pref.getString('url');

              try {
                final res = await http.post(
                  Uri.parse("$ip/UpdateStock/"),
                  body: {'pid': pid, 'stock': controller.text.trim()},
                );

                final result = json.decode(res.body);
                if (result['status'] == 'ok') {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Stock updated for $name"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() => futureProducts = fetchProducts());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Update failed"), backgroundColor: Colors.red),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Network error")),
                );
              }
            },
            icon: const Icon(Icons.check, size: 18),
            label: const Text("Update"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // Delete Product with Confirmation
  void deleteProduct(String pid, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Delete Product?", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete\n"$name"?\n\nThis cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final pref = await SharedPreferences.getInstance();
    final String? ip = pref.getString('url');

    try {
      final res = await http.post(Uri.parse("$ip/DeleteProduct/"), body: {'pid': pid});
      final result = json.decode(res.body);

      if (result['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$name deleted"), backgroundColor: Colors.red),
        );
        setState(() => futureProducts = fetchProducts());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manage Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No products yet",
                    style: TextStyle(fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text("Tap + to add your first product", style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          final products = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () => Future(() => setState(() => futureProducts = fetchProducts())),
            color: Colors.orange,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (_, index) {
                final p = products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            p['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Product Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['productname'],
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
                                  Text(
                                    p['price'],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.inventory, size: 16, color: p['stock'] == '0' ? Colors.red : Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Stock: ${p['stock']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: p['stock'] == '0' ? Colors.red : Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                p['details'],
                                style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons
                        Column(
                          children: [
                            // Update Stock
                            GestureDetector(
                              onTap: () => showUpdateStockDialog(p['id'], p['stock'], p['productname']),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.edit, color: Colors.orange, size: 24),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Delete
                            GestureDetector(
                              onTap: () => deleteProduct(p['id'], p['productname']),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.delete_forever, color: Colors.red, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const add_product())),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}