import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatelessWidget {
  final List<String> videoUrls = [
    'https://youtu.be/hnh_xDOxnzE?si=VN0Uy6mnsJX77j1L',
    'https://youtu.be/yIPX-FNJ9qk?si=C-bT2PdhEgp-uDVu',
    'https://youtu.be/wNupLeP1CtQ?si=T9FyOx5s7WXPfH0e',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cafe Videos',
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          String videoId = YoutubePlayer.convertUrlToId(videoUrls[index])!;
          String thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";

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
              height: 290, // tinggi card seragam
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
                      child: Text(
                        'Video ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

class VideoDetailPage extends StatefulWidget {
  final String videoId;
  VideoDetailPage({required this.videoId});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late YoutubePlayerController _controller;

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
    _controller.dispose(); // penting untuk menghindari memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        backgroundColor: Colors.brown[800],
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.brown[800],
      ),
    );
  }
}
