import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql/pages/add_video_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VideoPage extends StatefulWidget {
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final String baseUrl = "http://10.0.2.2/kopi/";

  // ===== VIDEO BAWAAN =====
  final List<String> videoUrls = [
    'https://youtu.be/ba-XAIskH_g?si=db_kPNkRxAXUti3c',
    'https://youtu.be/yIPX-FNJ9qk?si=C-bT2PdhEgp-uDVu',
    'https://youtu.be/S0Kez6MERGE?si=WlfKsr76LGVO5f94',
    'https://youtu.be/RpC8NVgIfnc?si=ouXi6JcbSJCE2Nwo',
    'https://youtu.be/jmvX6XyvCy0?si=edJIrD8SaWmWYYwZ',
    'https://youtu.be/w8pjAV8u2OE?si=SYelwU2s-vACjgK0',
    'https://youtu.be/tGv7CUutzqU?si=Yz9mkzt-psg08fej',
  ];

  final List<String> videoTitles = [
    'Juicy Luicy - Lantas',
    'Idgitaf - Sedia Aku Sebelum Hujan',
    'Hindia - Cincin',
    'Vierra - Rasa Ini',
    'Raim Laode - Bersenja Gurau',
    '.Feast - Tarot',
    'The 1975 - About You',
  ];

  // ===== VIDEO USER (DARI DB) =====
  List<Map<String, String>> userVideos = [];

  @override
  void initState() {
    super.initState();
    _loadUserVideosFromDB();
  }

  // ================= LOAD VIDEO USER =================
  Future<void> _loadUserVideosFromDB() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) return;

    final response = await http.get(
      Uri.parse("${baseUrl}get_videos.php?user_id=$userId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        userVideos = data
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
  // Future<void> _addVideoToDB(Map result) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString("user_id");

  //   await http.post(
  //     Uri.parse("${baseUrl}add_video.php"),
  //     body: {"user_id": userId, "title": result['title'], "url": result['url']},
  //   );

  //   _loadUserVideosFromDB();
  // }

  @override
  Widget build(BuildContext context) {
    final allUrls = [...videoUrls, ...userVideos.map((e) => e['url']!)];

    final allTitles = [...videoTitles, ...userVideos.map((e) => e['title']!)];

    return Scaffold(
      appBar: AppBar(
        title: Text('Music Videos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddVideoPage()),
              );

              if (changed == true) {
                _loadUserVideosFromDB();
              }
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: allUrls.length,
        itemBuilder: (context, index) {
          final videoId = YoutubePlayer.convertUrlToId(allUrls[index])!;
          final thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";

          final isUserVideo = index >= videoUrls.length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoDetailPage(videoId: videoId),
                ),
              );
            },
            child: SizedBox(
              height: 290,
              child: Card(
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(thumbnailUrl, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              allTitles[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isUserVideo)
                            Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.brown[600],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= VIDEO DETAIL =================

class VideoDetailPage extends StatefulWidget {
  final String videoId;
  VideoDetailPage({required this.videoId});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        setState(() => _isFullScreen = true);
      },
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        setState(() => _isFullScreen = false);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.brown[800],
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  title: Text(
                    'Video Player',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.brown[800],
                  iconTheme: IconThemeData(color: Colors.white),
                ),
          body: Center(child: player),
        );
      },
    );
  }
}
