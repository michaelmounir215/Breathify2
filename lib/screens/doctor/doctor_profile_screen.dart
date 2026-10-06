import 'package:breathify2/screens/patient/upload_xray_screen.dart';
import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../services/database_service.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Profile')),
      body: FutureBuilder<DoctorModel>(
        future: DatabaseService().getDoctor(doctorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Doctor profile error: ${snapshot.error}'); // Debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Doctor not found'));
          }
          final doctor = snapshot.data!;
          print('Doctor profile: ${doctor.id}, photo: ${doctor.profilePhotoUrl}'); // Debugging
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: doctor.profilePhotoUrl != null
                      ? NetworkImage(doctor.profilePhotoUrl!)
                      : null,
                  onBackgroundImageError: (error, stackTrace) {
                    print('Profile image load error for doctor ${doctor.id}: $error'); // Debugging
                  },
                  child: doctor.profilePhotoUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  'Dr. ${doctor.name}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text('Specialty: ${doctor.specialty}'),
                if (doctor.description != null) ...[
                  const SizedBox(height: 10),
                  Text(doctor.description!),
                ],
                if (doctor.experience != null) ...[
                  const SizedBox(height: 10),
                  Text('Experience: ${doctor.experience}'),
                ],
                if (doctor.government != null) ...[
                  const SizedBox(height: 10),
                  Text('Government: ${doctor.government}'),
                ],
                const SizedBox(height: 10),
                Text('Rating: ${doctor.averageRating.toStringAsFixed(1)} (${doctor.ratingCount} reviews)'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadXrayScreen(doctorId: doctor.id),
                      ),
                    );
                  },
                  child: const Text('Upload X-ray'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}