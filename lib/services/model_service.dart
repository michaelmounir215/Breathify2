import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ModelService {
  Future<String> predictXray(File xrayFile) async {
    final uri = Uri.parse('http://192.168.1.162:8000/predict'); // replace with your FastAPI IP address

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('file', xrayFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['prediction'].toString();
    } else {
      throw Exception('Failed to get prediction from model');
    }
  }
}
