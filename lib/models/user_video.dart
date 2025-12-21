class UserVideo {
  final String id;
  final String title;
  final String url;

  UserVideo({
    required this.id,
    required this.title,
    required this.url,
  });

  factory UserVideo.fromJson(Map<String, dynamic> json) {
    return UserVideo(
      id: json['id'],
      title: json['title'],
      url: json['youtube_url'],
    );
  }
}
