import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import '../models/xray_request_model.dart';
import '../models/report_model.dart';
import '../models/support_chat_model.dart';
import '../models/rating_model.dart';
import '../models/feedback_model.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await _client
          .from('doctors')
          .select('*, users!doctors_id_fkey(name, profile_photo_url)')
          .eq('users.role', 'doctor');
      print('Doctors fetched: $response'); // Debugging
      if (response.isEmpty) {
        print('No doctors found in database');
      }
      return response.map((json) => DoctorModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      rethrow;
    }
  }

  Future<DoctorModel> getDoctor(String doctorId) async {
    try {
      final response = await _client
          .from('doctors')
          .select('*, users!doctors_id_fkey(name, profile_photo_url)')
          .eq('id', doctorId)
          .eq('users.role', 'doctor')
          .single();
      print('Doctor fetched: $response'); // Debugging
      return DoctorModel.fromJson(response);
    } catch (e) {
      print('Error fetching doctor: $e');
      throw Exception('Failed to fetch doctor: $e');
    }
  }

  Future<PatientModel> getPatient(String patientId) async {
    try {
      final response = await _client
          .from('patients')
          .select()
          .eq('id', patientId)
          .single();
      print('Patient fetched: $response'); // Debugging
      return PatientModel.fromJson(response);
    } catch (e) {
      print('Error fetching patient: $e');
      throw Exception('Failed to fetch patient: $e');
    }
  }

  Future<List<XrayRequestModel>> getDoctorRequests(String doctorId) async {
    try {
      final response = await _client.from('xray_requests').select().eq('doctor_id', doctorId).eq('status', 'pending');
      print('Requests fetched for doctor $doctorId: $response'); // Debugging
      return response.map((json) => XrayRequestModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching requests: $e');
      throw Exception('Failed to fetch requests: $e');
    }
  }

  Future<XrayRequestModel> getXrayRequest(String requestId) async {
    try {
      final response = await _client.from('xray_requests').select().eq('id', requestId).single();
      print('Request fetched: $response'); // Debugging
      return XrayRequestModel.fromJson(response);
    } catch (e) {
      print('Error fetching request: $e');
      throw Exception('Failed to fetch request: $e');
    }
  }

  Future<void> createXrayRequest({
    required String patientId,
    required String doctorId,
    required String xrayUrl,
    required String modelPrediction,
  }) async {
    try {
      await _client.from('xray_requests').insert({
        'patient_id': patientId,
        'doctor_id': doctorId,
        'xray_url': xrayUrl,
        'model_prediction': modelPrediction,
        'status': 'pending',
      });
      print('Created X-ray request for doctor: $doctorId'); // Debugging
    } catch (e) {
      print('Error creating X-ray request: $e');
      throw Exception('Failed to create X-ray request: $e');
    }
  }

  Future<void> updateXrayRequestStatus(String requestId, String status) async {
    try {
      await _client.from('xray_requests').update({'status': status}).eq('id', requestId);
      print('Updated request $requestId status to: $status'); // Debugging
    } catch (e) {
      print('Error updating request status: $e');
      throw Exception('Failed to update request status: $e');
    }
  }

  Future<void> createReport({
    required String xrayRequestId,
    required String doctorId,
    required String patientId,
    required String diagnosis,
    required bool isModelCorrect,
  }) async {
    try {
      await _client.from('reports').insert({
        'xray_request_id': xrayRequestId,
        'doctor_id': doctorId,
        'patient_id': patientId,
        'diagnosis': diagnosis,
        'is_model_correct': isModelCorrect,
      });
      print('Created report for request: $xrayRequestId'); // Debugging
    } catch (e) {
      print('Error creating report: $e');
      throw Exception('Failed to create report: $e');
    }
  }

  Future<List<ReportModel>> getPatientReports(String patientId) async {
    try {
      final response = await _client.from('reports').select().eq('patient_id', patientId);
      print('Reports fetched for patient $patientId: $response'); // Debugging
      return response.map((json) => ReportModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Failed to fetch reports: $e');
    }
  }

  Future<void> createRating({
    required String patientId,
    required String doctorId,
    required int rating,
  }) async {
    try {
      await _client.from('ratings').insert({
        'patient_id': patientId,
        'doctor_id': doctorId,
        'rating': rating,
      });
      print('Created rating for doctor: $doctorId'); // Debugging
    } catch (e) {
      print('Error creating rating: $e');
      throw Exception('Failed to create rating: $e');
    }
  }

  Future<void> createFeedback({
    required String patientId,
    required String doctorId,
    required String comment,
  }) async {
    try {
      await _client.from('feedback').insert({
        'patient_id': patientId,
        'doctor_id': doctorId,
        'comment': comment,
      });
      print('Created feedback for doctor: $doctorId'); // Debugging
    } catch (e) {
      print('Error creating feedback: $e');
      throw Exception('Failed to create feedback: $e');
    }
  }

  Future<List<FeedbackModel>> getDoctorFeedback(String doctorId) async {
    try {
      final response = await _client.from('feedback').select().eq('doctor_id', doctorId);
      print('Feedback fetched for doctor $doctorId: $response'); // Debugging
      return response.map((json) => FeedbackModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching feedback: $e');
      throw Exception('Failed to fetch feedback: $e');
    }
  }

  Future<void> createSupportMessage({
    required String userId,
    required String message,
    required bool isFromUser,
  }) async {
    try {
      await _client.from('support_chats').insert({
        'user_id': userId,
        'message': message,
        'is_from_user': isFromUser,
      });
      print('Created support message for user: $userId'); // Debugging
    } catch (e) {
      print('Error creating support message: $e');
      throw Exception('Failed to create support message: $e');
    }
  }

  Future<List<SupportChatModel>> getSupportMessages(String userId) async {
    try {
      final response = await _client.from('support_chats').select().eq('user_id', userId).order('created_at');
      print('Support messages fetched for user $userId: $response'); // Debugging
      return response.map((json) => SupportChatModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching support messages: $e');
      throw Exception('Failed to fetch support messages: $e');
    }
  }
}