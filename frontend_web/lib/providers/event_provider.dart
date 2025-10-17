import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
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

  Future<void> loadEvents() async {
    _setLoading(true);
    _setError(null);

    try {
      _events = await ApiService.getEvents();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> createEvent(EventCreateRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final event = await ApiService.createEvent(request);
      _events.add(event);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<Event?> getEvent(int eventId) async {
    try {
      return await ApiService.getEvent(eventId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void clearError() {
    _setError(null);
  }
}
