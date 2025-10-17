class ProductionConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://ticketcolombia-backend.onrender.com',
  );
  
  static const String appName = 'Ticket Colombia';
  static const String appVersion = '1.0.0';
  
  // Configuraciones de producción
  static const bool isProduction = true;
  static const bool enableLogging = false;
  static const bool enableDebugMode = false;
}
