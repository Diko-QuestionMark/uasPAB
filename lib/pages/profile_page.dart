import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? photoPath;
  File? _previewImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileFromDatabase();
  }

  /// AMBIL DATA PROFIL
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
          photoPath = data["photo"];
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  /// LOGOUT
  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.brown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomePage()),
      );
    }
  }

  /// PILIH & UPLOAD FOTO
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    setState(() {
      _previewImage = File(pickedFile.path);
    });

    await _uploadPhoto(pickedFile.path);
  }

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
      _previewImage = null;
      await _loadProfileFromDatabase();
    }
  }

  /// EMAIL
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fedriko447@gmail.com',
      queryParameters: {'subject': 'Bantuan Aplikasi'},
    );

    final success = await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi email')),
      );
    }
  }

  /// TELEPON
  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+6282179989407');

    final success = await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
      );
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
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  /// FOTO PROFIL
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.brown[300],
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
                  ),

                  const SizedBox(height: 30),

                  /// INFORMASI PROFIL
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Informasi Profil",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Card(
                      elevation: 0,
                      color: Colors.brown[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.brown.shade100),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.email, color: Colors.brown),
                            title: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            subtitle: Text(
                              email,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(thickness: 0.8, color: Colors.brown.shade100),

                          ListTile(
                            dense: true,
                            leading: Icon(Icons.person, color: Colors.brown),
                            title: Text("Status"),
                            subtitle: Text("User Aktif"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(thickness: 1, height: 48),
                  ),

                  /// BANTUAN (PAKAI CARD)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Bantuan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Text(
                      "Hubungi kami jika kamu mengalami kendala",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _launchEmail,
                            child: const ListTile(
                              leading: Icon(Icons.email, color: Colors.brown),
                              title: Text("Email Support"),
                              subtitle: Text("fedriko447@gmail.com"),
                              trailing: Icon(Icons.chevron_right),
                            ),
                          ),
                          const Divider(height: 1),
                          InkWell(
                            onTap: _launchPhone,
                            child: const ListTile(
                              leading: Icon(Icons.phone, color: Colors.brown),
                              title: Text("Telepon Support"),
                              subtitle: Text("+62 821-7998-9407"),
                              trailing: Icon(Icons.chevron_right),
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
}
