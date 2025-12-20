import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadEmail();
    _loadProfilePhoto();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email") ?? "-";
    });
  }

  Future<void> _loadProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photoPath = prefs.getString("photo_path");
    });
  }

  Future<void> _uploadPhoto(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id"); // WAJIB ADA
    print("USER ID = $userId");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://10.0.2.2/kopi/upload_profile.php"),
    );

    request.fields['user_id'] = userId!;
    request.files.add(await http.MultipartFile.fromPath('photo', path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final photo = jsonDecode(respStr)['photo'];

      prefs.setString("photo_path", photo);

      setState(() {
        photoPath = photo;
      });
    }
  }

  File? _image; // preview lokal
  String? photoPath; // dari MySQL (ex: uploads/profile/user_1.jpg)
  final String baseUrl = "http://10.0.2.2/kopi/";

  final ImagePicker _picker = ImagePicker();
  // contoh email (nanti bisa dari session / shared preferences)
  String email = "";
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path); // preview cepat
    });

    await _uploadPhoto(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// FOTO PROFIL
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.brown[300],
                  backgroundImage: photoPath != null
                      ? NetworkImage(baseUrl + photoPath!)
                      : _image != null
                      ? FileImage(_image!) as ImageProvider
                      : null,
                  child: photoPath == null && _image == null
                      ? const Icon(Icons.person, size: 80, color: Colors.white)
                      : null,
                ),

                /// ICON EDIT
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.brown[800],
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// CARD INFO
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.brown),
                        title: const Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.brown),
                        title: const Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("User Aktif"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
