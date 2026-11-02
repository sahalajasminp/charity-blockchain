// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:handsofhope/handicapped/view%20charity.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CharityPage extends StatefulWidget {
//   const CharityPage({super.key});
//
//   @override
//   State<CharityPage> createState() => _CharityPageState();
// }
//
// class _CharityPageState extends State<CharityPage> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController needdateController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();
//
//   Future<void> pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         needdateController.text =
//         "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//       });
//     }
//   }
//
//   Future<void> sendAmount() async {
//     final prefs = await SharedPreferences.getInstance();
//     final ip = prefs.getString("url") ?? "";
//     final lid = prefs.getString("lid") ?? "";
//
//     if (amountController.text.isEmpty) {
//       showMessage("Please enter amount");
//       return;
//     }
//
//     if (needdateController.text.isEmpty) {
//       showMessage("Please select a date");
//       return;
//     }
//
//     final response = await http.post(
//       Uri.parse("$ip/person_addcharity_post/"),
//       body: {
//         'amount': amountController.text,
//         'date': needdateController.text,
//         'name': titleController.text,
//         'details': detailsController.text,
//         'lid': lid,
//       },
//     );
//
//     final data = jsonDecode(response.body);
//
//     if (data['status'] == 'ok') {
//       showMessage("Charity Added Successfully!");
//       amountController.clear();
//       titleController.clear();
//       needdateController.clear();
//       detailsController.clear();
//
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewCharityDetails()));
//
//     } else {
//       showMessage("Failed to add charity");
//     }
//   }
//
//   void showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Charity")),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Purpose',
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               TextField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Amount',
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               TextField(
//                 controller: needdateController,
//                 readOnly: true,   // <-- IMPORTANT
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Need Date',
//                   suffixIcon: Icon(Icons.calendar_month),
//                 ),
//                 onTap: pickDate,  // Open DatePicker
//               ),
//
//               const SizedBox(height: 10),
//
//               TextField(
//                 controller: detailsController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Details',
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: sendAmount,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                   ),
//                   child: const Text("Submit", style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handsofhope/handicapped/view%20charity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CharityPage extends StatefulWidget {
  const CharityPage({super.key});

  @override
  State<CharityPage> createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController needdateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        needdateController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> sendAmount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("url") ?? "";
    final lid = prefs.getString("lid") ?? "";

    try {
      final response = await http.post(
        Uri.parse("$ip/person_addcharity_post/"),
        body: {
          'amount': amountController.text,
          'date': needdateController.text,
          'name': titleController.text,
          'details': detailsController.text,
          'lid': lid,
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        showMessage("Charity Added Successfully!", isError: false);
        amountController.clear();
        titleController.clear();
        needdateController.clear();
        detailsController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewCharityDetails()),
        );
      } else {
        showMessage("Failed to add charity", isError: true);
      }
    } catch (e) {
      showMessage("Error: $e", isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Send Charity Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Request Charity Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in the details below to submit your request',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Purpose Field
                    _buildLabel('Purpose / Title', Icons.title),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      decoration: _buildInputDecoration(
                        hint: 'e.g., Medical Treatment, Education',
                        icon: Icons.edit_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a purpose';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Amount Field
                    _buildLabel('Amount Required', Icons.currency_rupee),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        hint: 'Enter amount in ₹',
                        icon: Icons.monetization_on_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Date Field
                    _buildLabel('Need By Date', Icons.calendar_today),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: needdateController,
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        hint: 'Select date',
                        icon: Icons.calendar_month_outlined,
                      ),
                      onTap: pickDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Details Field
                    _buildLabel('Additional Details', Icons.description),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: detailsController,
                      maxLines: 4,
                      decoration: _buildInputDecoration(
                        hint: 'Provide detailed information about your request',
                        icon: Icons.notes_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : sendAmount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Submit Request',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.green[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your request will be reviewed by our team and donors.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green[900],
                              ),
                            ),
                          ),
                        ],
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
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.green[700]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[700]!, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    needdateController.dispose();
    detailsController.dispose();
    super.dispose();
  }
}