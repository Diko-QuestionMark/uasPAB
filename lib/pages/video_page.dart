import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class VideoPage extends StatelessWidget {
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
    'The 1975 - About You'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Videos', style: TextStyle(color: Colors.white)),
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
                        videoTitles[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
        setState(() {
          _isFullScreen = true;
        });
      },
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge, // ⬅️ KUNCI UTAMA
        );

        setState(() {
          _isFullScreen = false;
        });
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
