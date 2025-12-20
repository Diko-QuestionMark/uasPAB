import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String baseUrl = "http://10.0.2.2/kopi/";
  final ImagePicker _picker = ImagePicker();

  String email = "";
  String? photoPath; // ⬅️ FOTO DARI DATABASE
  File? _previewImage; // ⬅️ PREVIEW SEMENTARA
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileFromDatabase();
  }

  /// 🔹 AMBIL DATA PROFIL LANGSUNG DARI DATABASE
  Future<void> _loadProfileFromDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_profile.php?user_id=$userId"),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          email = data["email"];
          photoPath = data["photo"]; // nama file dari DB
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔹 PILIH FOTO → UPLOAD → UPDATE DB
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    setState(() {
      _previewImage = File(pickedFile.path); // preview cepat
    });

    await _uploadPhoto(pickedFile.path);
  }

  /// 🔹 UPLOAD FOTO KE SERVER
  Future<void> _uploadPhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) return;

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${baseUrl}upload_profile.php"),
    );

    request.fields['user_id'] = userId;
    request.files.add(await http.MultipartFile.fromPath('photo', path));

    final response = await request.send();

    if (response.statusCode == 200) {
      // setelah upload → ambil ulang dari database
      _previewImage = null;
      await _loadProfileFromDatabase();
    }
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
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// FOTO PROFIL
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.brown[300],

                        // PRIORITAS TAMPILAN FOTO
                        // 1. Preview setelah pilih foto
                        // 2. Foto dari database
                        backgroundImage: _previewImage != null
                            ? FileImage(_previewImage!)
                            : (photoPath != null
                                      ? NetworkImage(
                                          "${baseUrl}$photoPath?t=${DateTime.now().millisecondsSinceEpoch}",
                                        )
                                      : null)
                                  as ImageProvider?,

                        child: (_previewImage == null && photoPath == null)
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              )
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

                  /// INFO CARD
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
                              leading: const Icon(
                                Icons.email,
                                color: Colors.brown,
                              ),
                              title: const Text(
                                "Email",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(email),
                            ),
                            const Divider(),
                            const ListTile(
                              leading: Icon(Icons.person, color: Colors.brown),
                              title: Text(
                                "Status",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("User Aktif"),
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
