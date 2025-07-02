class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? role;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.role,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };

    if (role != null) {
      map['role'] = role;
    }

    return map;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      role: map['role'], // ← 추가
    );
  }
}
