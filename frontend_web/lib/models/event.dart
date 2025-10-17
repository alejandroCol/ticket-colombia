class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String location;
  final int createdBy;
  final String createdAt;
  final bool isActive;
  final List<TicketType> ticketTypes;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.createdBy,
    required this.createdAt,
    required this.isActive,
    this.ticketTypes = const [],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      createdBy: json['createdBy'] ?? 1,
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      isActive: json['isActive'] ?? true,
      ticketTypes: _parseTicketTypes(json['ticketTypes']),
    );
  }

  static List<TicketType> _parseTicketTypes(dynamic ticketTypesData) {
    if (ticketTypesData == null) return [];
    
    // Si es una lista, parsear normalmente
    if (ticketTypesData is List) {
      return ticketTypesData.map((e) => TicketType.fromJson(e)).toList();
    }
    
    // Si es un número (cantidad), crear ticket types mock
    if (ticketTypesData is int) {
      return List.generate(ticketTypesData, (index) => TicketType(
        id: index + 1,
        eventId: 0,
        name: 'Tipo ${index + 1}',
        price: 50.0 + (index * 25.0),
        maxQuantity: 100,
        currentQuantity: 0,
      ));
    }
    
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'location': location,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'isActive': isActive,
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketType {
  final int id;
  final int eventId;
  final String name;
  final double price;
  final int? maxQuantity;
  final int currentQuantity;

  TicketType({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    this.maxQuantity,
    required this.currentQuantity,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      maxQuantity: json['maxQuantity'],
      currentQuantity: json['currentQuantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'price': price,
      'maxQuantity': maxQuantity,
      'currentQuantity': currentQuantity,
    };
  }
}

class EventCreateRequest {
  final String name;
  final String description;
  final String date;
  final String location;
  final List<TicketTypeCreateRequest> ticketTypes;

  EventCreateRequest({
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.ticketTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'location': location,
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketTypeCreateRequest {
  final String name;
  final double price;
  final int? maxQuantity;

  TicketTypeCreateRequest({
    required this.name,
    required this.price,
    this.maxQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'maxQuantity': maxQuantity,
    };
  }
}
