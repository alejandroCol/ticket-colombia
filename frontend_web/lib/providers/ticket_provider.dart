import 'package:flutter/foundation.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _error;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadTickets(int eventId) async {
    _setLoading(true);
    _setError(null);

    try {
      _tickets = await ApiService.getTickets(eventId);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> createTicket(TicketCreateRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      print('Creating ticket with request: ${request.toJson()}');
      final ticket = await ApiService.createTicket(request);
      print('Ticket created successfully: ${ticket.toJson()}');
      _tickets.add(ticket);
      _setLoading(false);
      return true;
    } catch (e) {
      print('Error creating ticket: $e');
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<TicketValidationResponse?> validateTicket(String qrCode) async {
    try {
      final request = TicketValidationRequest(qrCode: qrCode);
      return await ApiService.validateTicket(request);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void clearTickets() {
    _tickets.clear();
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
