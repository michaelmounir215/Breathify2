import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/doctor_model.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/navigation_bar.dart';
import '../role_selection_screen.dart';
import 'doctor_profile_screen.dart';
import 'patient_profile_screen.dart';
import 'support_chat_screen.dart';
import 'reports_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        body: Center(child: LinearProgressIndicator()), // Updated here
      );
    }

    final screens = [
      FutureBuilder<List<DoctorModel>>(
        future: _databaseService.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator()); // Updated here
          }
          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}'); // Debugging
            return Center(child: Text('Error fetching doctors: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No doctors available in snapshot'); // Debugging
            return const Center(child: Text('No doctors available'));
          }
          print('Doctors count: ${snapshot.data!.length}'); // Debugging
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final doctor = snapshot.data![index];
              print('Rendering doctor: ${doctor.id}, name: ${doctor.name}, photo: ${doctor.profilePhotoUrl}'); // Debugging
              return DoctorCard(
                doctor: doctor,
                onTap: () {
                  print('Navigating to DoctorProfileScreen with doctorId: ${doctor.id}'); // Debugging
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorProfileScreen(doctorId: doctor.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      const PatientProfileScreen(),
      const SupportChatScreen(),
      const ReportsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathify'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}