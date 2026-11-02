import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handsofhope/handicapped/add%20quantity.dart';
import 'package:handsofhope/product_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HandicappedViewOthersProductsPage extends StatefulWidget {
  const HandicappedViewOthersProductsPage({super.key});

  @override
  State<HandicappedViewOthersProductsPage> createState() =>
      _HandicappedViewOthersProductsPageState();
}

class _HandicappedViewOthersProductsPageState
    extends State<HandicappedViewOthersProductsPage> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;

  String baseUrl = "";
  String mediaUrl = "";
  String lid = "";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initPrefsAndFetch();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _filterProducts();
      });
    });
  }

  Future<void> _initPrefsAndFetch() async {
    prefs = await SharedPreferences.getInstance();
    baseUrl = prefs?.getString('url') ?? "";
    mediaUrl = prefs?.getString('img_url') ?? "";
    lid = prefs?.getString('lid') ?? "";

    if (baseUrl.isEmpty || mediaUrl.isEmpty || lid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login required")),
        );
      }
      setState(() => isLoading = false);
      return;
    }

    await _fetchProducts();
  }

  void _filterProducts() {
    if (_searchQuery.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((p) {
        final name = (p['productname'] ?? "").toString().toLowerCase();
        final details = (p['details'] ?? "").toString().toLowerCase();
        return name.contains(_searchQuery) || details.contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> _fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/view_others_products/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            products = data['data'];
            filteredProducts = products;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load products")),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty
                ? Icons.search_off
                : Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? "No products found for \"$_searchQuery\""
                : "No products available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.clear, color: Colors.orange),
              label: const Text("Clear search"),
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Explore Products",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.orange))
          : filteredProducts.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchProducts,
        color: Colors.orange,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final p = filteredProducts[index];

            String imageUrl = p['image'] ?? '';
            if (imageUrl.startsWith('/media/') ||
                !imageUrl.startsWith('http')) {
              imageUrl = mediaUrl.endsWith('/')
                  ? mediaUrl + imageUrl.substring(1)
                  : '$mediaUrl$imageUrl';
            }

            final bool inStock = p['stock']?.toString() != "0";

            return GestureDetector(
              onTap: () async {
                await prefs?.setString("pid", p['id'].toString());
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProductDetailsPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with stock badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          child: Image.network(
                            imageUrl,
                            height: 115,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 115,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                              inStock ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              inStock ? "In Stock" : "Out of Stock",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Flexible content to avoid overflow
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(10, 10, 10, 8),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['productname'] ?? "Product",
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee,
                                    color: Colors.green, size: 16),
                                Text(
                                  p['price']?.toString() ?? "0",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(), // Push button to bottom
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const AddQuantityPage()),
                                  );
                                },
                                child: const Text("Purchase"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
