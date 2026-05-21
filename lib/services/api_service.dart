import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const bool usePhysicalDevice = true;
  static const bool useHomeWifi = true;
  static const String baseUrl = usePhysicalDevice
      ? useHomeWifi
          ? 'http://192.168.1.8:3000/api'
          : 'http://10.102.88.214:3000/api'
      : 'http://10.0.2.2:3000/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>?> login(
    String phone,
    String password,
  ) async {
    final uri = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> registerUser({
    required String username,
    required String phone,
    required String password,
    String? email,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'username': username,
        'phone': phone,
        'password': password,
        'email': email ?? '',
      }),
    );

    return response.statusCode == 201;
  }

  static Future<bool> checkPhoneExists(String phone) async {
    final uri = Uri.parse('$baseUrl/auth/user/exists?phone=$phone');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['exists'] as bool? ?? false;
    }
    return false;
  }

  static Future<bool> updatePassword({
    required String phone,
    required String newPassword,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/reset-password');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({'phone': phone, 'newPassword': newPassword}),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> updateUser({
    required String id,
    required String username,
    required String phone,
    String? email,
  }) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode({
        'username': username,
        'phone': phone,
        'email': email ?? '',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> submitReport({
    required String reportedBy,
    required String reportLocation,
    required List<String> symptoms,
    required String foodSource,
    required String? exposureDistrict,
    required Map<String, dynamic> location,
  }) async {
    final uri = Uri.parse('$baseUrl/reports');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'reportedBy': reportedBy,
        'reportLocation': reportLocation,
        'symptoms': symptoms,
        'foodSource': foodSource,
        'exposureDistrict': exposureDistrict,
        'location': location,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<List<Map<String, dynamic>>> getUserReports(
    String userId,
  ) async {
    final uri = Uri.parse('$baseUrl/reports/user/$userId');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<DateTime?> getLastReportTime(String userId) async {
    final uri = Uri.parse('$baseUrl/reports/user/$userId/last');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = data['lastReportAt'] as String?;
      return raw == null ? null : DateTime.tryParse(raw);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getOfficialAnalytics({
    String? year,
    String? month,
    String? caseClassification,
  }) async {
    final query = {
      if (year != null && year != 'all') 'year': year,
      if (month != null && month != 'all') 'month': month,
      if (caseClassification != null && caseClassification != 'all')
        'caseClassification': caseClassification,
    };

    final uri = Uri.parse(
      '$baseUrl/official-cases/analytics',
    ).replace(queryParameters: query);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<Map<String, dynamic>> getPredictionChart({
    String district = 'all',
    String range = '3',
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/predictions/chart?district=$district&range=$range',
      ),
    );

    return jsonDecode(response.body);
  }
}
