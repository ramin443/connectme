class TextPost {
  int? id;
  final String username;
  final String userFullName;
  final int userAvatar;
  final String datetime;
  final String postText;
  final int likeCount;
  final int commentCount;
  final int shareCount;

  TextPost({
    required this.username,
    required this.userFullName,
    required this.userAvatar,
    required this.datetime,
    required this.postText,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });
  TextPost.fromDatabase({
    required this.id,
    required this.username,
    required this.userFullName,
    required this.userAvatar,
    required this.datetime,
    required this.postText,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });
  // Factory constructor to create a TextPost from a map (e.g., JSON data)
  factory TextPost.fromJson(Map<String, dynamic> json) {
    return TextPost(
      username: json['username'] as String,
      userFullName: json['userFullName'] as String,
      userAvatar: json['userAvatar'] as int,
      datetime: json['datetime'] as String,
      postText: json['postText'] as String,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      shareCount: json['shareCount'] as int,
    );
  }

  // Convert the TextPost object to a map (e.g., for serialization)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userFullName': userFullName,
      'userAvatar': userAvatar,
      'datetime': datetime,
      'postText': postText,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
    };
  }
}
