import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoadingLocation = false;

  // Function to fetch lat/long from place using Nominatim (OpenStreetMap)
  Future<void> fetchLatLongFromPlace(String place) async {
    if (place.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a place");
      return;
    }

    setState(() {
      isLoadingLocation = true;
    });

    final encodedPlace = Uri.encodeComponent(place);
    final url =
        'https://nominatim.openstreetmap.org/search?q=$encodedPlace&format=json&limit=1';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'MyFlutterApp/1.0', // Required by Nominatim policy
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        if (data.isNotEmpty) {
          final lat = data[0]['lat'];
          final lon = data[0]['lon'];

          latitudeController.text = lat;
          longitudeController.text = lon;

          Fluttertoast.showToast(msg: "Location fetched successfully!");
        } else {
          Fluttertoast.showToast(msg: "Location not found");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch location");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: nameController,
              ),
              const SizedBox(height: 10),

              // Place field with "Get Location" button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Place'),
                      controller: placeController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isLoadingLocation
                        ? null
                        : () => fetchLatLongFromPlace(placeController.text),
                    child: isLoadingLocation
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text("Get Location"),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'District'),
                controller: districtController,
              ),

              // Latitude & Longitude (auto-filled)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      controller: latitudeController,
                      keyboardType: TextInputType.number,
                      readOnly: true, // Prevent manual edit (optional)
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      controller: longitudeController,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                controller: usernameController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: sendData,
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    String name = nameController.text.trim();
    String place = placeController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String district = districtController.text.trim();
    String latitude = latitudeController.text.trim();
    String longitude = longitudeController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty ||
        place.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not configured");
      return;
    }

    final api = Uri.parse('$url/UserRegistration/');

    try {
      final request = http.MultipartRequest('POST', api);

      request.fields['name'] = name;
      request.fields['place'] = place;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['district'] = district;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['username'] = username;
      request.fields['password'] = password;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Registration successful!");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Registration failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}