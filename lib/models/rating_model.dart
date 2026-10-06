class RatingModel {
  final String id;
  final String patientId;
  final String doctorId;
  final int rating;

  RatingModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.rating,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      rating: json['rating'],
    );
  }
}