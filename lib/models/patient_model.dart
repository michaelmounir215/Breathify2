class PatientModel {
  final String id;
  final String name;
  final DateTime birthDate;

  PatientModel({
    required this.id,
    required this.name,
    required this.birthDate,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      birthDate: DateTime.parse(json['birth_date'] ?? '2000-01-01'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
    };
  }
}