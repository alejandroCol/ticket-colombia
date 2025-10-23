import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/ticket.dart';

class ApiService {
  // Producción
  static const String baseUrl = 'https://ticketcolombia-backend.onrender.com';
  
  // Desarrollo
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Para Android emulator
  // static const String baseUrl = 'http://localhost:8080'; // Para iOS simulator
  
  static const String authTokenKey = 'auth_token';

  // Headers helper
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(authTokenKey);
    
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Auth endpoints
  static Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(data);
      
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(authTokenKey, loginResponse.token);
      
      return loginResponse;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    }
  }

  static Future<User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to get user info');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authTokenKey);
  }

  // Ticket validation
  static Future<TicketValidationResponse> validateTicket(TicketValidationRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tickets/validate'),
      headers: await _getHeaders(),
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TicketValidationResponse.fromJson(data);
    } else {
      throw Exception('Failed to validate ticket');
    }
  }
}

