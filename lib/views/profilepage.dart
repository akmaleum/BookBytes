import 'dart:io';

import 'package:bookbytes/shared/mydrawer.dart';
import 'package:bookbytes/views/changepassword.dart';
import 'package:bookbytes/views/loginpage.dart';
import 'package:bookbytes/views/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userdata;

  const ProfilePage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;
  late ImagePicker _imagePicker;
  XFile? _pickedImage; // Updated to remove the late keyword

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _showImageSourceOptions() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await _imagePicker.pickImage(
                        source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {
                        _pickedImage = pickedImage;
                      });
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _pickedImage = pickedImage;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      drawer: MyDrawer(
        page: 'account',
        userdata: widget.userdata,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.2,
              padding: const EdgeInsets.all(8),
              child: Card(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _showImageSourceOptions();
                      },
                      child: ClipOval(
                        // Wrap with ClipOval to make it circular
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.15,
                          child: _pickedImage != null
                              ? Image.file(
                                  File(_pickedImage!.path),
                                  fit: BoxFit
                                      .cover, // Use BoxFit.cover to ensure the image covers the circular container
                                )
                              : Image.asset(
                                  'assets/images/profile.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.userdata.username.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userdata.useremail.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Divider(
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.035,
              alignment: Alignment.center,
              color: Colors.brown,
              width: screenWidth,
              child: const Text(
                "UPDATE ACCOUNT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  buildProfileButton("UPDATE NAME", () {}),
                  buildDivider(),
                  buildProfileButton("UPDATE PASSWORD", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  }),
                  buildDivider(),
                  buildProfileButton("UPDATE PHONE NUMBER", () {}),
                  buildDivider(),
                  buildProfileButton("UPDATE ADDRESS", () {}),
                  buildDivider(),
                  buildProfileButton("NEW REGISTRATION", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => const RegistrationPage(),
                      ),
                    );
                  }),
                  buildDivider(),
                  buildProfileButton("LOGIN", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => const LoginPage(),
                      ),
                    );
                  }),
                  buildDivider(),
                  buildProfileButton("LOGOUT", () {
                    // Handle logout logic
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      height: 2,
      color: Colors.blueGrey,
    );
  }

  Widget buildProfileButton(String label, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
