import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';
import '../../services/model_service.dart';
import 'thank_you_screen.dart';
import '../role_selection_screen.dart';

class UploadXrayScreen extends StatefulWidget {
  final String doctorId;

  const UploadXrayScreen({super.key, required this.doctorId});

  @override
  _UploadXrayScreenState createState() => _UploadXrayScreenState();
}

class _UploadXrayScreenState extends State<UploadXrayScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final ModelService _modelService = ModelService();
  File? _xrayImage;
  String? _error;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _xrayImage = File(pickedFile.path);
      });
    }
  }

  void _uploadXray(String patientId) async {
    if (_xrayImage == null) {
      setState(() {
        _error = 'Please select an X-ray image';
      });
      return;
    }
    try {
      final xrayUrl = await _storageService.uploadXray(patientId, _xrayImage!.path);
      final prediction = await _modelService.predictXray(xrayUrl);
      await _databaseService.createXrayRequest(
        patientId: patientId,
        doctorId: widget.doctorId,
        xrayUrl: xrayUrl,
        modelPrediction: prediction,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ThankYouScreen()),
      );
    } catch (e) {
      setState(() {
        _error = 'Failed to upload X-ray: $e';
      });
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
      appBar: AppBar(title: const Text('Upload X-ray')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _xrayImage != null
                    ? Image.file(_xrayImage!, fit: BoxFit.cover)
                    : const Center(child: Text('Select X-ray Image')),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadXray(user.id),
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}