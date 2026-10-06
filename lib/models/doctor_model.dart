class DoctorModel {
  final String id;
  final String specialty;
  final String? description;
  final String? experience;
  final String? government;
  final double averageRating;
  final int ratingCount;
  final String? profilePhotoUrl;
  final String name;

  DoctorModel({
    required this.id,
    required this.specialty,
    this.description,
    this.experience,
    this.government,
    required this.averageRating,
    required this.ratingCount,
    this.profilePhotoUrl,
    required this.name,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      specialty: json['specialty'] ?? '',
      description: json['description'],
      experience: json['experience'],
      government: json['government'],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] ?? 0,
      profilePhotoUrl: json['users'] != null ? json['users']['profile_photo_url'] : null,
      name: json['users'] != null ? json['users']['name'] ?? '' : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialty': specialty,
      'description': description,
      'experience': experience,
      'government': government,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'profile_photo_url': profilePhotoUrl,
      'name': name,
    };
  }
}