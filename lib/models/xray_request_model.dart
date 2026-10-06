class XrayRequestModel {
  final String id;
  final String patientId;
  final String? doctorId;
  final String xrayUrl;
  final String? modelPrediction;
  final String status;

  XrayRequestModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.xrayUrl,
    this.modelPrediction,
    required this.status,
  });

  factory XrayRequestModel.fromJson(Map<String, dynamic> json) {
    return XrayRequestModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      xrayUrl: json['xray_url'],
      modelPrediction: json['model_prediction'],
      status: json['status'],
    );
  }
}