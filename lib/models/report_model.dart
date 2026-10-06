class ReportModel {
  final String id;
  final String xrayRequestId;
  final String doctorId;
  final String patientId;
  final String diagnosis;
  final bool? isModelCorrect;

  ReportModel({
    required this.id,
    required this.xrayRequestId,
    required this.doctorId,
    required this.patientId,
    required this.diagnosis,
    this.isModelCorrect,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      xrayRequestId: json['xray_request_id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      diagnosis: json['diagnosis'],
      isModelCorrect: json['is_model_correct'],
    );
  }
}