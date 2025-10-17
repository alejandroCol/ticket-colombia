# Ticket Colombia API Documentation

## Overview
Ticket Colombia is a complete ticketing system with backend API, web frontend, and mobile app support.

## Architecture
- **Backend**: Kotlin + Ktor + PostgreSQL + Exposed ORM
- **Frontend Web**: Flutter Web
- **Frontend Mobile**: Flutter Mobile
- **Database**: PostgreSQL with proper relationships
- **Authentication**: JWT tokens
- **Email**: Resend API with PDF attachments

## Database Schema

### Users Table
- `id` (Primary Key)
- `username` (Unique)
- `email` (Unique)
- `password` (Hashed)
- `created_at`

### Events Table
- `id` (Primary Key)
- `name`
- `description`
- `date`
- `location`
- `created_at`

### Ticket Types Table
- `id` (Primary Key)
- `event_id` (Foreign Key to Events)
- `name`
- `price`
- `description`
- `max_quantity`
- `created_at`

### Tickets Table
- `id` (Primary Key)
- `event_id` (Foreign Key to Events)
- `ticket_type_id` (Foreign Key to Ticket Types)
- `attendee_name`
- `attendee_email`
- `attendee_phone`
- `qr_code` (Unique)
- `is_used` (Boolean)
- `status`
- `created_at`

## API Endpoints

### Authentication

#### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "jwt-token",
  "user": {
    "id": 1,
    "username": "string",
    "email": "string",
    "createdAt": "2025-01-01T00:00:00"
  }
}
```

#### POST /auth/login
Login user.

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "jwt-token",
  "user": {
    "id": 1,
    "username": "string",
    "email": "string",
    "createdAt": "2025-01-01T00:00:00"
  }
}
```

#### GET /auth/me
Get current user information.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Response:**
```json
{
  "id": 1,
  "username": "string",
  "email": "string",
  "createdAt": "2025-01-01T00:00:00"
}
```

### Events

#### GET /events
Get all events.

**Response:**
```json
[
  {
    "id": 1,
    "name": "Concierto",
    "description": "Descripción del evento",
    "date": "2025-01-01T20:00:00",
    "location": "Bogotá",
    "ticketTypes": [
      {
        "id": 1,
        "name": "General",
        "price": 50.0,
        "description": "Entrada general",
        "maxQuantity": 100
      }
    ],
    "createdAt": "2025-01-01T00:00:00"
  }
]
```

#### GET /events/{id}
Get event by ID.

**Response:**
```json
{
  "id": 1,
  "name": "Concierto",
  "description": "Descripción del evento",
  "date": "2025-01-01T20:00:00",
  "location": "Bogotá",
  "ticketTypes": [...],
  "createdAt": "2025-01-01T00:00:00"
}
```

#### POST /events
Create a new event.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "date": "2025-01-01T20:00:00",
  "location": "string",
  "ticketTypes": [
    {
      "name": "General",
      "price": 50.0,
      "description": "Entrada general",
      "maxQuantity": 100
    }
  ]
}
```

**Response:**
```json
{
  "id": 1,
  "name": "string",
  "description": "string",
  "date": "2025-01-01T20:00:00",
  "location": "string",
  "ticketTypes": [...],
  "createdAt": "2025-01-01T00:00:00"
}
```

### Tickets

#### GET /tickets?eventId={id}
Get tickets for a specific event.

**Response:**
```json
[
  {
    "id": 1,
    "eventId": 1,
    "ticketTypeId": 1,
    "attendeeName": "Juan Pérez",
    "attendeeEmail": "juan@example.com",
    "attendeePhone": "1234567890",
    "qrCode": "QR-1234567890-1234",
    "isUsed": false,
    "status": "VALID",
    "createdAt": "2025-01-01T00:00:00"
  }
]
```

#### POST /tickets
Create a new ticket.

**Headers:**
```
Authorization: Bearer <jwt-token>
```

**Request Body:**
```json
{
  "eventId": 1,
  "ticketTypeId": 1,
  "attendeeName": "string",
  "attendeeEmail": "string",
  "attendeePhone": "string"
}
```

**Response:**
```json
{
  "id": 1,
  "eventId": 1,
  "ticketTypeId": 1,
  "attendeeName": "string",
  "attendeeEmail": "string",
  "attendeePhone": "string",
  "qrCode": "QR-1234567890-1234",
  "isUsed": false,
  "status": "VALID",
  "createdAt": "2025-01-01T00:00:00"
}
```

#### POST /tickets/validate
Validate a ticket by QR code.

**Request Body:**
```json
{
  "qrCode": "QR-1234567890-1234"
}
```

**Response:**
```json
{
  "isValid": true,
  "isUsed": false,
  "message": "Ticket válido",
  "ticket": {
    "id": 1,
    "eventId": 1,
    "ticketTypeId": 1,
    "attendeeName": "string",
    "attendeeEmail": "string",
    "attendeePhone": "string",
    "qrCode": "QR-1234567890-1234",
    "isUsed": false,
    "status": "VALID",
    "createdAt": "2025-01-01T00:00:00"
  }
}
```

## Production Deployment

### Prerequisites
- PostgreSQL 12+
- Java 16+
- Gradle 8+

### Environment Variables
```bash
export DATABASE_URL="jdbc:postgresql://localhost:5432/ticketcolombia"
export DATABASE_USERNAME="ticketcolombia"
export DATABASE_PASSWORD="ticketcolombia123"
export JWT_SECRET="your-super-secret-jwt-key"
export RESEND_API_KEY="your-resend-api-key"
export FROM_EMAIL="your-verified-email@domain.com"
```

### Deployment Steps
1. Clone the repository
2. Install PostgreSQL
3. Run the deployment script:
   ```bash
   cd backend
   chmod +x deploy.sh
   ./deploy.sh
   ```

### API URLs
- **Development**: http://localhost:8080
- **Health Check**: http://localhost:8080/health
- **API Documentation**: http://localhost:8080/

## Mobile App Integration

The API is designed to work seamlessly with Flutter mobile apps. All endpoints return JSON responses that can be easily consumed by Flutter's `http` package or similar HTTP clients.

### Authentication Flow
1. User registers/logs in via `/auth/register` or `/auth/login`
2. Store the JWT token securely
3. Include the token in the `Authorization` header for protected endpoints

### Error Handling
All endpoints return appropriate HTTP status codes:
- `200 OK` - Success
- `201 Created` - Resource created
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

## Security Features
- JWT-based authentication
- Password hashing with SHA-256
- CORS enabled for web applications
- Input validation on all endpoints
- SQL injection protection via Exposed ORM

## Email Features
- Automatic ticket email with PDF attachment
- QR code generation and validation
- Professional email templates
- Resend API integration for reliable delivery
