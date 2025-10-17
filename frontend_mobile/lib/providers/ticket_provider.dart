import 'package:flutter/foundation.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class TicketProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  TicketValidationResponse? _lastValidation;

  bool get isLoading => _isLoading;
  String? get error => _error;
  TicketValidationResponse? get lastValidation => _lastValidation;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<TicketValidationResponse?> validateTicket(String qrCode) async {
    _setLoading(true);
    _setError(null);

    try {
      final request = TicketValidationRequest(qrCode: qrCode);
      final response = await ApiService.validateTicket(request);
      _lastValidation = response;
      _setLoading(false);
      return response;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  void clearValidation() {
    _lastValidation = null;
    _setError(null);
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
