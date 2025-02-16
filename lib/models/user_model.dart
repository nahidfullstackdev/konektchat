class UserModel {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String? profilePic;
  final bool isOnline;
  final List<String> groupId;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    this.profilePic,
    required this.isOnline,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      profilePic: map['profilePic'] as String?,
      isOnline: map['isOnline'] as bool,
      groupId: List<String>.from(map['groupId'] ?? []),
    );
  }
}
