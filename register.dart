// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:handsofhope/login.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Handicapped_signup(title: 'Exhaust AI'),
//     );
//   }
// }
//
// class Handicapped_signup extends StatefulWidget {
//   const Handicapped_signup({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<Handicapped_signup> createState() => _Handicapped_signupState();
// }
//
// class _Handicapped_signupState extends State<Handicapped_signup> {
//   String gender = "Male";
//   File? _image;
//   File? _proof;
//   final ImagePicker _picker = ImagePicker();
//   final ImagePicker _picker2 = ImagePicker();
//   bool _isLoading = false;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController pinController = TextEditingController();
//   TextEditingController districtController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController usernamecontroller = TextEditingController();
//   // TextEditingController laticontroller = TextEditingController();
//   // TextEditingController longicontroller = TextEditingController();
//   TextEditingController agecontroller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF667eea),
//               Color(0xFF764ba2),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header
//               Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Handicapped Registration',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           'Create your worker account',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Form Container
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Profile Photo Section
//                         Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 'Profile Photo',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey.shade800,
//                                 ),
//                               ),
//                               SizedBox(height: 15),
//                               GestureDetector(
//                                 onTap: () => _showImagePickerModal(context, true),
//                                 child: Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: Color(0xFF667eea),
//                                       width: 3,
//                                     ),
//                                     image: _image != null
//                                         ? DecorationImage(
//                                       image: FileImage(_image!),
//                                       fit: BoxFit.cover,
//                                     )
//                                         : null,
//                                   ),
//                                   child: _image == null
//                                       ? Icon(
//                                     Icons.add_a_photo,
//                                     size: 40,
//                                     color: Colors.grey.shade400,
//                                   )
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30),
//
//                         // ID Proof Section
//                         Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 'ID Proof',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey.shade800,
//                                 ),
//                               ),
//                               SizedBox(height: 15),
//                               GestureDetector(
//                                 onTap: () => _showImagePickerModal(context, false),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 150,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                       color: Color(0xFF667eea),
//                                       width: 2,
//                                     ),
//                                     image: _proof != null
//                                         ? DecorationImage(
//                                       image: FileImage(_proof!),
//                                       fit: BoxFit.cover,
//                                     )
//                                         : null,
//                                   ),
//                                   child: _proof == null
//                                       ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.upload_file,
//                                         size: 40,
//                                         color: Colors.grey.shade400,
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         'Upload ID Proof',
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30),
//
//                         // Personal Information
//                         _buildSectionTitle('Personal Information'),
//                         SizedBox(height: 15),
//                         _buildTextField(nameController, 'Full Name', Icons.person_outline),
//                         SizedBox(height: 15),
//                         _buildTextField(emailController, 'Email', Icons.email_outlined),
//                         SizedBox(height: 15),
//                         _buildTextField(phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
//                         SizedBox(height: 15),
//                         _buildTextField(agecontroller, 'Age', Icons.cake_outlined),
//                         SizedBox(height: 20),
//
//                         // Gender Selection
//                         Text(
//                           'Gender',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Row(
//                           children: [
//                             _buildGenderChip('Male'),
//                             SizedBox(width: 10),
//                             _buildGenderChip('Female'),
//                             SizedBox(width: 10),
//                             _buildGenderChip('Other'),
//                           ],
//                         ),
//                         SizedBox(height: 30),
//
//                         // Address Information
//                         _buildSectionTitle('Address Information'),
//                         SizedBox(height: 15),
//                         _buildTextField(placeController, 'Place', Icons.location_on_outlined),
//                         SizedBox(height: 15),
//                         _buildTextField(districtController, 'District', Icons.map_outlined),
//                         SizedBox(height: 15),
//                         _buildTextField(pinController, 'Pincode', Icons.pin_drop_outlined, keyboardType: TextInputType.number),
//                         SizedBox(height: 30),
//
//                         SizedBox(height: 30),
//
//                         // Account Credentials
//                         _buildSectionTitle('Account Credentials'),
//                         SizedBox(height: 15),
//                         _buildTextField(usernamecontroller, 'Username', Icons.account_circle_outlined),
//                         SizedBox(height: 15),
//                         _buildTextField(passwordController, 'Password', Icons.lock_outline, isPassword: true),
//                         SizedBox(height: 40),
//
//                         // Submit Button
//                         Container(
//                           width: double.infinity,
//                           height: 55,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                             ),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0xFF667eea).withOpacity(0.5),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(15),
//                               onTap: _isLoading ? null : () {
//                                 _send_data();
//                               },
//                               child: Center(
//                                 child: _isLoading
//                                     ? SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2.5,
//                                   ),
//                                 )
//                                     : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Create Account',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Icon(Icons.arrow_forward, color: Colors.white),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF667eea),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String label,
//       IconData icon, {
//         bool isPassword = false,
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: keyboardType,
//       style: TextStyle(fontSize: 16),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Color(0xFF667eea)),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//       ),
//     );
//   }
//
//   Widget _buildGenderChip(String genderOption) {
//     bool isSelected = gender == genderOption;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             gender = genderOption;
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: isSelected ? Color(0xFF667eea) : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: isSelected ? Color(0xFF667eea) : Colors.grey.shade300,
//               width: 2,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               genderOption,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.grey.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showImagePickerModal(BuildContext context, bool isProfilePhoto) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 50,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Select Image',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 leading: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF667eea).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(Icons.camera_alt, color: Color(0xFF667eea)),
//                 ),
//                 title: Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   if (isProfilePhoto) {
//                     _pickImage(ImageSource.camera);
//                   } else {
//                     _pickImage2(ImageSource.camera);
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF667eea).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(Icons.photo_library, color: Color(0xFF667eea)),
//                 ),
//                 title: Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   if (isProfilePhoto) {
//                     _pickImage(ImageSource.gallery);
//                   } else {
//                     _pickImage2(ImageSource.gallery);
//                   }
//                 },
//               ),
//               SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _send_data() async {
//     String name = nameController.text;
//     String email = emailController.text;
//     String place = placeController.text;
//     String district = districtController.text;
//     String pincode = pinController.text;
//     String phone = phoneController.text;
//     String age = agecontroller.text;
//     // String latitude = laticontroller.text;
//     // String longitude = longicontroller.text;
//     String password = passwordController.text;
//     String username = usernamecontroller.text;
//
//     if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please fill all required fields');
//       return;
//     }
//
//     if (_image == null || _proof == null) {
//       Fluttertoast.showToast(msg: 'Please upload profile photo and ID proof');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//
//     final api = Uri.parse('$url/handicapped_signup/');
//
//     try {
//       final request = await http.MultipartRequest('POST', api);
//
//       request.fields['name'] = name;
//       request.fields['email'] = email;
//       request.fields['phone'] = phone;
//       request.fields['pincode'] = pincode;
//       request.fields['district'] = district;
//       request.fields['place'] = place;
//       request.fields['username'] = username;
//       request.fields['password'] = password;
//       request.fields['age'] = age;
//       request.fields['gender'] = gender;
//       // request.fields['latitude'] = latitude;
//       // request.fields['longitude'] = longitude;
//
//       request.files.add(await http.MultipartFile.fromPath(
//         'photo',
//         _image!.path,
//       ));
//
//       request.files.add(await http.MultipartFile.fromPath(
//         'proof',
//         _proof!.path,
//       ));
//
//       var response = await request.send();
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var data = jsonDecode(responseData);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Registration Successful!');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Registration Failed');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server Error');
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _pickImage2(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       setState(() {
//         _proof = File(pickedFile.path);
//       });
//     }
//   }}


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handsofhope/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // <-- added for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Handicapped_signup(title: 'Exhaust AI'),
    );
  }
}

class Handicapped_signup extends StatefulWidget {
  const Handicapped_signup({super.key, required this.title});

  final String title;

  @override
  State<Handicapped_signup> createState() => _Handicapped_signupState();
}

class _Handicapped_signupState extends State<Handicapped_signup> {
  String gender = "Male";
  File? _image;
  File? _proof;
  final ImagePicker _picker = ImagePicker();
  final ImagePicker _picker2 = ImagePicker();
  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController dobController = TextEditingController(); // <-- DOB Controller

  // ---------------------- DOB DatePicker -----------------------
  Future<void> selectDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF667eea),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  // -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Handicapped Registration',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Create your worker account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // -------------- Form Starts -----------------
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------------- Profile Photo ----------------
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Profile Photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: () =>
                                    _showImagePickerModal(context, true),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF667eea),
                                      width: 3,
                                    ),
                                    image: _image != null
                                        ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: _image == null
                                      ? Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey.shade400,
                                  )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        // ---------------- ID Proof ----------------
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'ID Proof',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: () =>
                                    _showImagePickerModal(context, false),
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Color(0xFF667eea),
                                      width: 2,
                                    ),
                                    image: _proof != null
                                        ? DecorationImage(
                                      image: FileImage(_proof!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: _proof == null
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload_file,
                                        size: 40,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Upload ID Proof',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),
                        _buildSectionTitle('Personal Information'),
                        SizedBox(height: 15),

                        _buildTextField(nameController, 'Full Name',
                            Icons.person_outline),
                        SizedBox(height: 15),

                        _buildTextField(emailController, 'Email',
                            Icons.email_outlined),
                        SizedBox(height: 15),

                        _buildTextField(phoneController, 'Phone Number',
                            Icons.phone_outlined,
                            keyboardType: TextInputType.phone),
                        SizedBox(height: 15),

                        // ---------------- DOB Field ----------------
                        GestureDetector(
                          onTap: selectDOB,
                          child: AbsorbPointer(
                            child: _buildTextField(
                              dobController,
                              'Date of Birth (DOB)',
                              Icons.calendar_today,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          'Gender',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 10),

                        Row(
                          children: [
                            _buildGenderChip('Male'),
                            SizedBox(width: 10),
                            _buildGenderChip('Female'),
                            SizedBox(width: 10),
                            _buildGenderChip('Other'),
                          ],
                        ),

                        SizedBox(height: 30),
                        _buildSectionTitle('Address Information'),
                        SizedBox(height: 15),

                        _buildTextField(placeController, 'Place',
                            Icons.location_on_outlined),
                        SizedBox(height: 15),

                        _buildTextField(districtController, 'District',
                            Icons.map_outlined),
                        SizedBox(height: 15),

                        _buildTextField(pinController, 'Pincode',
                            Icons.pin_drop_outlined,
                            keyboardType: TextInputType.number),
                        SizedBox(height: 30),

                        _buildSectionTitle('Account Credentials'),
                        SizedBox(height: 15),

                        _buildTextField(usernamecontroller, 'Username',
                            Icons.account_circle_outlined),
                        SizedBox(height: 15),

                        _buildTextField(passwordController, 'Password',
                            Icons.lock_outline,
                            isPassword: true),
                        SizedBox(height: 40),

                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF667eea),
                                Color(0xFF764ba2)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Color(0xFF667eea).withOpacity(0.5),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: _isLoading ? null : () => _send_data(),
                              child: Center(
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Widgets -----------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF667eea),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF667eea)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildGenderChip(String genderOption) {
    bool isSelected = gender == genderOption;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            gender = genderOption;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF667eea) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                isSelected ? Color(0xFF667eea) : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              genderOption,
              style: TextStyle(
                color:
                isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------- API SEND FUNCTION ------------------

  void _send_data() async {
    String name = nameController.text;
    String email = emailController.text;
    String place = placeController.text;
    String district = districtController.text;
    String pincode = pinController.text;
    String phone = phoneController.text;
    String dob = dobController.text; // <-- DOB
    String password = passwordController.text;
    String username = usernamecontroller.text;

    if (name.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        dob.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
      return;
    }

    if (_image == null || _proof == null) {
      Fluttertoast.showToast(msg: 'Please upload profile photo and ID proof');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    final api = Uri.parse('$url/handicapped_signup/');

    try {
      final request = http.MultipartRequest('POST', api);

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['pincode'] = pincode;
      request.fields['district'] = district;
      request.fields['place'] = place;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['age'] = dob; // <-- sending DOB
      request.fields['gender'] = gender;

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _image!.path,
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'proof',
        _proof!.path,
      ));

      var response = await request.send();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Registration Successful!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Registration Failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server Error');
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  // ---------------- Image Pickers ----------------

  void _showImagePickerModal(BuildContext context, bool isProfilePhoto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  if (isProfilePhoto) {
                    _pickImage(ImageSource.camera);
                  } else {
                    _pickImage2(ImageSource.camera);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  if (isProfilePhoto) {
                    _pickImage(ImageSource.gallery);
                  } else {
                    _pickImage2(ImageSource.gallery);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _pickImage2(ImageSource source) async {
    final pickedFile = await _picker2.pickImage(source: source);
    if (pickedFile != null) setState(() => _proof = File(pickedFile.path));
  }
}
