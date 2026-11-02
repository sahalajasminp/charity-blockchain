import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'handicapped/manage_products.dart';

class add_product extends StatefulWidget {
  const add_product({super.key});

  @override
  State<add_product> createState() => _add_productState();
}

class _add_productState extends State<add_product> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _productnameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _productnameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _add_product() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all fields correctly", backgroundColor: Colors.red);
      return;
    }
    if (_image == null) {
      Fluttertoast.showToast(msg: "Please select a product image", backgroundColor: Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('url');
    final String? lid = prefs.getString('lid');

    if (url == null || lid == null) {
      Fluttertoast.showToast(msg: "Server not configured");
      setState(() => _isLoading = false);
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$url/User_add_product/'));
      request.fields.addAll({
        'productname': _productnameController.text.trim(),
        'stock': _stockController.text.trim(),
        'price': _priceController.text.trim(),
        'details': _detailsController.text.trim(),
        'lid': lid,
      });
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Product added successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ManageProduct()),
              (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: data['msg'] ?? "Failed to add product", backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error: $e", backgroundColor: Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Add New Product", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Colors.orange, Color(0xFFFF8A65)]),
                boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const Icon(Icons.add_box_rounded, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            Text("List Your Product", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 8),
            Text("Fill in the details and add a beautiful photo", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 30),

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Product Name
                    _buildTextField(_productnameController, "Product Name", Icons.inventory_2_outlined),

                    const SizedBox(height: 20),

                    // Stock & Price
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_stockController, "Stock Quantity", Icons.numbers, keyboardType: TextInputType.number)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(_priceController, "Price (₹)", Icons.currency_rupee, keyboardType: TextInputType.number)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Details
                    _buildTextField(_detailsController, "Product Description", Icons.description, maxLines: 5),

                    const SizedBox(height: 28),

                    // Image Section
                    Text("Product Image *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _image == null ? Colors.orange.shade200 : Colors.transparent, width: 3, style: BorderStyle.solid),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
                        ),
                        child: _image == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 60, color: Colors.orange.shade400),
                            const SizedBox(height: 12),
                            Text("Tap to add photo", style: TextStyle(fontSize: 16, color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
                          ],
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Stack(
                            children: [
                              Image.file(_image!, fit: BoxFit.cover, width: double.infinity, height: 200),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => setState(() => _image = null),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Image Source Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library, color: Colors.orange),
                            label: const Text("Gallery"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.orange, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt, color: Colors.orange),
                            label: const Text("Camera"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.orange, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _add_product,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: Colors.orange.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 28, width: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                            : const Text("ADD PRODUCT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange.shade700),
        filled: true,
        fillColor: Colors.orange.shade50.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red, width: 2)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Please enter $label";
        if (keyboardType == TextInputType.number && int.tryParse(value) == null) return "Invalid number";
        return null;
      },
    );
  }
}