import 'package:flutter/material.dart';
import '../models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200], // Set a default background color
          backgroundImage: doctor.profilePhotoUrl != null && doctor.profilePhotoUrl!.isNotEmpty
              ? NetworkImage(doctor.profilePhotoUrl!)
              : null,
          onBackgroundImageError: doctor.profilePhotoUrl != null && doctor.profilePhotoUrl!.isNotEmpty
              ? (exception, stackTrace) {
            print('Image load error for doctor ${doctor.id}: $exception'); // Log the error
          }
              : null,
          child: (doctor.profilePhotoUrl == null || doctor.profilePhotoUrl!.isEmpty)
              ? const Icon(Icons.person, size: 25, color: Colors.grey)
              : null,
        ),
        title: Text('Dr. ${doctor.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialty: ${doctor.specialty}'),
            if (doctor.description != null) Text(doctor.description!),
            Text('Rating: ${doctor.averageRating.toStringAsFixed(1)} (${doctor.ratingCount} reviews)'),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}