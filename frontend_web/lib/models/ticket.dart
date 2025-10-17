import 'event.dart';

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
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      ticketTypeId: json['ticketTypeId'] ?? 0,
      attendeeName: json['attendeeName'] ?? '',
      attendeeEmail: json['attendeeEmail'] ?? '',
      attendeePhone: json['attendeePhone'] ?? '',
      qrCode: json['qrCode'] ?? '',
      status: json['status'] ?? 'VALID',
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      usedAt: json['usedAt'],
      usedBy: json['usedBy'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      ticketType: json['ticketType'] != null ? TicketType.fromJson(json['ticketType']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'ticketTypeId': ticketTypeId,
      'attendeeName': attendeeName,
      'attendeeEmail': attendeeEmail,
      'attendeePhone': attendeePhone,
      'qrCode': qrCode,
      'status': status,
      'createdAt': createdAt,
      'usedAt': usedAt,
      'usedBy': usedBy,
      'event': event?.toJson(),
      'ticketType': ticketType?.toJson(),
    };
  }
}

class TicketCreateRequest {
  final int eventId;
  final int ticketTypeId;
  final String attendeeName;
  final String attendeeEmail;
  final String attendeePhone;

  TicketCreateRequest({
    required this.eventId,
    required this.ticketTypeId,
    required this.attendeeName,
    required this.attendeeEmail,
    required this.attendeePhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'ticketTypeId': ticketTypeId,
      'attendeeName': attendeeName,
      'attendeeEmail': attendeeEmail,
      'attendeePhone': attendeePhone,
    };
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
