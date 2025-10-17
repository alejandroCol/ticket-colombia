import 'user.dart';

class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String location;
  final int createdBy;
  final String createdAt;
  final bool isActive;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.createdBy,
    required this.createdAt,
    required this.isActive,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      location: json['location'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
    );
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
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      price: json['price'].toDouble(),
      maxQuantity: json['maxQuantity'],
      currentQuantity: json['currentQuantity'],
    );
  }
}

class Ticket {
  final int id;
  final int eventId;
  final int ticketTypeId;
  final String attendeeName;
  final String attendeeEmail;
  final String attendeePhone;
  final String qrCode;
  final String status;
  final String createdAt;
  final String? usedAt;
  final int? usedBy;
  final Event? event;
  final TicketType? ticketType;

  Ticket({
    required this.id,
    required this.eventId,
    required this.ticketTypeId,
    required this.attendeeName,
    required this.attendeeEmail,
    required this.attendeePhone,
    required this.qrCode,
    required this.status,
    required this.createdAt,
    this.usedAt,
    this.usedBy,
    this.event,
    this.ticketType,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      eventId: json['eventId'],
      ticketTypeId: json['ticketTypeId'],
      attendeeName: json['attendeeName'],
      attendeeEmail: json['attendeeEmail'],
      attendeePhone: json['attendeePhone'],
      qrCode: json['qrCode'],
      status: json['status'],
      createdAt: json['createdAt'],
      usedAt: json['usedAt'],
      usedBy: json['usedBy'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      ticketType: json['ticketType'] != null ? TicketType.fromJson(json['ticketType']) : null,
    );
  }
}

class TicketValidationRequest {
  final String qrCode;

  TicketValidationRequest({
    required this.qrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
    };
  }
}

class TicketValidationResponse {
  final bool isValid;
  final Ticket? ticket;
  final String message;

  TicketValidationResponse({
    required this.isValid,
    this.ticket,
    required this.message,
  });

  factory TicketValidationResponse.fromJson(Map<String, dynamic> json) {
    return TicketValidationResponse(
      isValid: json['isValid'],
      ticket: json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null,
      message: json['message'],
    );
  }
}
