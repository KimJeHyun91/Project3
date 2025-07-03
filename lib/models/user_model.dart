class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? role;
  final int? balance;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.role,
    this.balance,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };

    if (balance != null) map['balance'] = balance;
    if (role != null) map['role'] = role;

    return map;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      role: map['role'],
      balance: map['balance'] ?? 0,
    );
  }
}
