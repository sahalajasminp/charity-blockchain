// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:handsofhope/handicapped/register.dart';
// import 'package:handsofhope/registration.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'handicapped/home.dart';
// import 'home.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController UsernameController=TextEditingController();
//   TextEditingController PasswordController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login page'),),
//       body: Padding(padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Username'),
//               controller: UsernameController,
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Password'),
//               controller: PasswordController,
//             ),
//             ElevatedButton(onPressed: sendData, child: Text('log in')),
//
//             TextButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => signup()));
//             }, child: Text('User signup')),
//
//
//             TextButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => Handicapped_signup(title: '')));
//             }, child: Text('Handicapped Person signup'))
//           ],
//         ),),
//     );
//   }
//   Future<void> sendData() async {
//     String username=UsernameController.text.trim();
//     String password=PasswordController.text.trim();
//
//     if(username.isEmpty||password.isEmpty) {
//       Fluttertoast.showToast(msg: 'fill the  fields');
//       return;
//     }
//
//     final sh= await SharedPreferences.getInstance();
//     String? url= sh.getString('url');
//
//     final api=Uri.parse('$url/FlutterLogin/');
//
//     try {
//       final request= await http.post(api,body: {
//         'username':username,
//         'password':password,
//       });
//
//       if(request.statusCode == 200) {
//         var data = jsonDecode(request.body);
//         if(data['status']=='ok') {
//
//           final sh = await SharedPreferences.getInstance();
//           String type = jsonDecode(request.body)['type'].toString();
//           sh.setString('type', type);
//           await sh.setString('lid', data['lid'].toString());
//
//           if (type == 'user'){
//             Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()));
//
//           }
//
//           else if(type == 'Handicapped'){
//             Navigator.push(context, MaterialPageRoute(builder: (context) =>HandHome()));
//
//           }
//
//           else{
//
//           }
//
//
//
//         }
//         else {
//           Fluttertoast.showToast(msg: 'invalid username or password');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'connection error');
//       }
//
//     }catch (e){
//       Fluttertoast.showToast(msg: 'error:$e');
//     }
//
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handsofhope/handicapped/register.dart';
import 'package:handsofhope/registration.dart';
import 'package:handsofhope/user_register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'handicapped/home.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[700]!, Colors.green[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Welcome Text
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue to Hands of Hope',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Username Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextFormField(
                      controller: UsernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline, color: Colors.green[700]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextFormField(
                      controller: PasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.green[700]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : sendData,
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
                          : const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'New to Hands of Hope?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Signup Buttons
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green[700]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => user_signup(title: '',)),
                        );
                      },
                      icon: Icon(Icons.person_add_outlined, color: Colors.green[700]),
                      label: Text(
                        'Sign Up as User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green[700]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Handicapped_signup(title: ''),
                          ),
                        );
                      },
                      icon: Icon(Icons.accessibility_new, color: Colors.green[700]),
                      label: Text(
                        'Sign Up as Handicapped Person',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    String username = UsernameController.text.trim();
    String password = PasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    final api = Uri.parse('$url/FlutterLogin/');

    try {
      final request = await http.post(api, body: {
        'username': username,
        'password': password,
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          final sh = await SharedPreferences.getInstance();
          String type = jsonDecode(request.body)['type'].toString();
          sh.setString('type', type);
          await sh.setString('lid', data['lid'].toString());

          Fluttertoast.showToast(
            msg: 'Login successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          if (type == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (type == 'Handicapped') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HandHome()),
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Invalid username or password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Connection error. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    UsernameController.dispose();
    PasswordController.dispose();
    super.dispose();
  }
}