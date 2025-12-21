import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  final String baseUrl = "http://10.0.2.2/kopi/";
  List<Map<String, String>> myVideos = [];

  bool _hasChanged = false; // 🔥 penanda perubahan

  @override
  void initState() {
    super.initState();
    _loadMyVideos();
  }

  // ================= LOAD VIDEO USER =================
  Future<void> _loadMyVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");
    if (userId == null) return;

    final response = await http.get(
      Uri.parse("${baseUrl}get_videos.php?user_id=$userId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        myVideos = data
            .map(
              (e) => {
                'id': e['id'].toString(),
                'title': e['title'].toString(),
                'url': e['youtube_url'].toString(),
              },
            )
            .toList();
      });
    }
  }

  // ================= TAMBAH VIDEO =================
  Future<void> _addVideo() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan link wajib diisi")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    await http.post(
      Uri.parse("${baseUrl}add_video.php"),
      body: {"user_id": userId, "title": title, "url": url},
    );

    _titleController.clear();
    _urlController.clear();

    _hasChanged = true;
    _loadMyVideos();
  }

  // ================= HAPUS VIDEO =================
  Future<void> _deleteVideo(String id) async {
    await http.post(Uri.parse("${baseUrl}delete_video.php"), body: {"id": id});

    _hasChanged = true;
    _loadMyVideos();
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Video"),
        content: const Text("Yakin ingin menghapus video ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            onPressed: () async {
              Navigator.pop(context); // tutup dialog
              await _deleteVideo(id); // lanjut hapus
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= EDIT VIDEO =================
  void _editVideo(Map video) {
    final editTitle = TextEditingController(text: video['title']);
    final editUrl = TextEditingController(text: video['url']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Video"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editTitle,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: editUrl,
              decoration: const InputDecoration(labelText: "Link YouTube"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await http.post(
                Uri.parse("${baseUrl}update_video.php"),
                body: {
                  "id": video['id'],
                  "title": editTitle.text,
                  "url": editUrl.text,
                },
              );

              _hasChanged = true;
              Navigator.pop(context); // tutup dialog
              _loadMyVideos();
            },
            child: const Text("Simpan"),
            
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanged);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Music Video',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.brown[800],
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _hasChanged);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== FORM TAMBAH VIDEO =====
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Video",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: "Link YouTube",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                  ),
                  onPressed: _addVideo,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "List Video",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 0),
              const SizedBox(height: 0),
              const Divider(thickness: 1),
              const SizedBox(height: 0),

              // ===== LIST VIDEO USER =====
              Expanded(
                child: myVideos.isEmpty
                    ? const Center(child: Text("Belum ada video"))
                    : ListView.separated(
                        itemCount: myVideos.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final video = myVideos[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.video_library,
                              color: Colors.brown,
                            ),
                            title: Text(video['title']!),
                            subtitle: Text(
                              video['url']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Wrap(
                              spacing: 0,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () => _editVideo(video),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _confirmDelete(video['id']!),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
