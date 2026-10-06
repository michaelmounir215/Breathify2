import 'package:breathify2/screens/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/doctor_model.dart';
import '../../models/rating_model.dart';
import '../../models/feedback_model.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import 'upload_xray_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final _ratingController = TextEditingController();
  final _feedbackController = TextEditingController();

  void _submitRating(String patientId) async {
    if (_ratingController.text.isNotEmpty) {
      final rating = int.tryParse(_ratingController.text);
      if (rating != null && rating >= 1 && rating <= 5) {
        await _databaseService.createRating(
          patientId: patientId,
          doctorId: widget.doctorId,
          rating: rating,
        );
        _ratingController.clear();
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a rating between 1 and 5')),
        );
      }
    }
  }

  void _submitFeedback(String patientId) async {
    if (_feedbackController.text.isNotEmpty) {
      await _databaseService.createFeedback(
        patientId: patientId,
        doctorId: widget.doctorId,
        comment: _feedbackController.text,
      );
      _feedbackController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null || user.role != 'patient') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Profile')),
      body: FutureBuilder<DoctorModel>(
        future: _databaseService.getDoctor(widget.doctorId),
        builder: (context, doctorSnapshot) {
          if (doctorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!doctorSnapshot.hasData) {
            return const Center(child: Text('Doctor not found'));
          }
          final doctor = doctorSnapshot.data!;
          print('Doctor profile URL: ${doctor.profilePhotoUrl}'); // Debug log
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: doctor.profilePhotoUrl != null && doctor.profilePhotoUrl!.isNotEmpty
                        ? Image.network(
                      doctor.profilePhotoUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image load error for doctor ${doctor.id}: $error, StackTrace: $stackTrace'); // Detailed error logging
                        return const Icon(Icons.person, size: 50, color: Colors.grey);
                      },
                    )
                        : const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Rating: ${doctor.averageRating.toStringAsFixed(1)} (${doctor.ratingCount} reviews)'),
                const SizedBox(height: 10),
                Text('Description: ${doctor.description ?? 'N/A'}'),
                const SizedBox(height: 10),
                Text('Experience: ${doctor.experience ?? 'N/A'}'),
                const SizedBox(height: 10),
                Text('Government: ${doctor.government ?? 'N/A'}'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ratingController,
                  decoration: const InputDecoration(labelText: 'Rate (1-5)'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () => _submitRating(user.id),
                  child: const Text('Submit Rating'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(labelText: 'Feedback'),
                  maxLines: 3,
                ),
                ElevatedButton(
                  onPressed: () => _submitFeedback(user.id),
                  child: const Text('Submit Feedback'),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<FeedbackModel>>(
                  future: _databaseService.getDoctorFeedback(widget.doctorId),
                  builder: (context, feedbackSnapshot) {
                    if (feedbackSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!feedbackSnapshot.hasData || feedbackSnapshot.data!.isEmpty) {
                      return const Text('No feedback available');
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Feedback:'),
                        ...feedbackSnapshot.data!.map((feedback) => ListTile(
                          title: Text(feedback.comment),
                        )),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadXrayScreen(doctorId: widget.doctorId),
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