import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/xray_request_model.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/patient_card.dart';
import '../role_selection_screen.dart';
import 'patient_request_screen.dart';
import 'doctor_profile_screen.dart';
import '../../models/doctor_model.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
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

    if (user == null || user.role != 'doctor') {
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

    final screens = [
      FutureBuilder<List<XrayRequestModel>>(
        future: _databaseService.getDoctorRequests(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error fetching requests: ${snapshot.error}'); // Debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No pending requests for doctor: ${user.id}'); // Debugging
            return const Center(child: Text('No pending requests'));
          }
          print('Requests count: ${snapshot.data!.length}'); // Debugging
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final request = snapshot.data![index];
              print('Rendering request: ${request.id}'); // Debugging
              return PatientCard(
                request: request,
                onTap: () {
                  print('Navigating to PatientRequestScreen with requestId: ${request.id}'); // Debugging
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientRequestScreen(requestId: request.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      DoctorProfileScreen(doctorId: user.id), // Fixed: Use user.id instead of doctor.id
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Breathify')),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medical_services),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}