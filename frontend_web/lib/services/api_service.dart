import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../models/ticket.dart';

class ApiService {
  static const String baseUrl = 'https://ticketcolombia-backend.onrender.com';
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

  static Future<LoginResponse> register(UserCreateRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
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
      throw Exception(error['error'] ?? 'Registration failed');
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

  // Event endpoints
  static Future<List<Event>> getEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get events');
    }
  }

  static Future<Event> createEvent(EventCreateRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: await _getHeaders(),
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        // Parse the event data from the response
        final eventData = json.decode(data['data']);
        return Event.fromJson(eventData);
      } else {
        throw Exception(data['message'] ?? 'Failed to create event');
      }
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to create event');
    }
  }

  static Future<Event> getEvent(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Event.fromJson(data);
    } else {
      throw Exception('Failed to get event');
    }
  }

  // Ticket endpoints
  static Future<List<Ticket>> getTickets(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tickets?eventId=$eventId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Ticket.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get tickets');
    }
  }

  static Future<Ticket> createTicket(TicketCreateRequest request) async {
    print('Sending request to: $baseUrl/tickets');
    print('Request body: ${json.encode(request.toJson())}');
    
    final response = await http.post(
      Uri.parse('$baseUrl/tickets'),
      headers: await _getHeaders(),
      body: json.encode(request.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Ticket.fromJson(data);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to create ticket');
    }
  }

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

  static String getQrImageUrl(String qrCode) {
    return '$baseUrl/tickets/qr/$qrCode';
  }
}
