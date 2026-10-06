class UserModel {
  final String id;
  final String email;
  final String role;
  final String name;
  final String? profilePhotoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    this.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}