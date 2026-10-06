import 'package:flutter/material.dart';
import '../models/xray_request_model.dart';

class PatientCard extends StatelessWidget {
  final XrayRequestModel request;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('Request ${request.id}'),
        subtitle: Text('Status: ${request.status}'),
        onTap: onTap,
      ),
    );
  }
}