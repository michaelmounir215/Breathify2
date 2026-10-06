import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/xray_request_model.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../patient/thank_you_screen.dart';
import '../role_selection_screen.dart';

class PatientRequestScreen extends StatefulWidget {
  final String requestId;

  const PatientRequestScreen({super.key, required this.requestId});

  @override
  _PatientRequestScreenState createState() => _PatientRequestScreenState();
}

class _PatientRequestScreenState extends State<PatientRequestScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final _diagnosisController = TextEditingController();
  bool _isModelCorrect = true;

  void _submitReport(String doctorId, String patientId, String xrayRequestId) async {
    if (_diagnosisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a diagnosis')),
      );
      return;
    }
    await _databaseService.createReport(
      xrayRequestId: xrayRequestId,
      doctorId: doctorId,
      patientId: patientId,
      diagnosis: _diagnosisController.text,
      isModelCorrect: _isModelCorrect,
    );
    await _databaseService.updateXrayRequestStatus(widget.requestId, 'completed');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ThankYouScreen()),
    );
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

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Request')),
      body: FutureBuilder<XrayRequestModel>(
        future: _databaseService.getXrayRequest(widget.requestId),
        builder: (context, requestSnapshot) {
          if (requestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!requestSnapshot.hasData) {
            return const Center(child: Text('Request not found'));
          }
          final request = requestSnapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(request.xrayUrl, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text('Model Prediction: ${request.modelPrediction ?? 'N/A'}'),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Model Prediction Correct?'),
                  value: _isModelCorrect,
                  onChanged: (value) {
                    setState(() {
                      _isModelCorrect = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(labelText: 'Diagnosis'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _submitReport(
                    user.id,
                    request.patientId,
                    request.id,
                  ),
                  child: const Text('Submit Report'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}