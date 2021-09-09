class CurrentUser {
  final String? userId;
  final String email;
  final String imageUrl;
  final String username;

  CurrentUser(
      {this.userId,
      required this.email,
      required this.imageUrl,
      required this.username});

  CurrentUser.fromJson(Map<String, Object?> json, String docId)
      : this(
          userId: docId,
          email: json['email']! as String,
          imageUrl: json['imageUrl']! as String,
          username: json['username']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'imageUrl': imageUrl,
      'username': username,
    };
  }
}
