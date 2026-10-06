class FeedbackModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String comment;

  FeedbackModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.comment,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      comment: json['comment'],
    );
  }
}