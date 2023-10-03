class User {
  final String name;
  final String bio;
  final int avatarIndex;
  final String username;

  User({
    required this.name,
    required this.bio,
    required this.avatarIndex,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      bio: json['bio'] as String,
      avatarIndex: json['avatarIndex'] as int,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'avatarIndex': avatarIndex,
      'username': username,
    };
  }
}
