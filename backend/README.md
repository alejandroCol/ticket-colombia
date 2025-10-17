# 🎫 Ticket Colombia - Backend API

API REST desarrollada en Kotlin + Ktor para el sistema de gestión de entradas.

## 🚀 Inicio Rápido

### Prerrequisitos
- Java 17+
- PostgreSQL 13+
- Gradle 8.3+

### Configuración de Base de Datos

```bash
# Crear base de datos PostgreSQL
sudo -u postgres psql
CREATE DATABASE ticketcolombia;
CREATE USER ticketuser WITH PASSWORD 'ticketpass';
GRANT ALL PRIVILEGES ON DATABASE ticketcolombia TO ticketuser;
\q
```

### Variables de Entorno (Opcional)

```bash
export DATABASE_URL=jdbc:postgresql://localhost:5432/ticketcolombia
export DATABASE_USER=ticketuser
export DATABASE_PASSWORD=ticketpass
```

### Ejecutar

```bash
# Ejecutar el servidor
./gradlew run

# O compilar y ejecutar
./gradlew build
java -jar build/libs/ticket-colombia-backend-1.0.0.jar
```

El servidor estará disponible en: `http://localhost:8080`

## 📚 API Endpoints

### Autenticación

#### POST /auth/register
Registrar nuevo usuario.

**Request:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "name": "Nombre Usuario"
}
```

**Response:**
```json
{
  "token": "jwt_token_aqui",
  "user": {
    "id": 1,
    "email": "usuario@ejemplo.com",
    "name": "Nombre Usuario",
    "createdAt": "2024-01-01T00:00:00"
  }
}
```

#### POST /auth/login
Iniciar sesión.

**Request:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

#### GET /auth/me
Obtener información del usuario actual (requiere autenticación).

### Eventos

#### POST /events
Crear nuevo evento (requiere autenticación).

**Request:**
```json
{
  "name": "Concierto Rock",
  "description": "Gran concierto de rock nacional",
  "date": "2024-12-31T20:00:00",
  "location": "Estadio El Campín",
  "ticketTypes": [
    {
      "name": "General",
      "price": 50000,
      "maxQuantity": 1000
    },
    {
      "name": "VIP",
      "price": 100000,
      "maxQuantity": 100
    }
  ]
}
```

#### GET /events
Listar eventos del usuario (requiere autenticación).

#### GET /events/{id}
Obtener evento específico (requiere autenticación).

### Entradas

#### POST /tickets
Crear nueva entrada (requiere autenticación).

**Request:**
```json
{
  "eventId": 1,
  "ticketTypeId": 1,
  "attendeeName": "Juan Pérez",
  "attendeeEmail": "juan@ejemplo.com",
  "attendeePhone": "3001234567"
}
```

#### GET /tickets?eventId={id}
Listar entradas de un evento (requiere autenticación).

#### POST /tickets/validate
Validar entrada por código QR.

**Request:**
```json
{
  "qrCode": "ABC123DEF456"
}
```

**Response:**
```json
{
  "isValid": true,
  "ticket": {
    "id": 1,
    "attendeeName": "Juan Pérez",
    "event": {
      "name": "Concierto Rock"
    },
    "ticketType": {
      "name": "General",
      "price": 50000
    },
    "status": "USED"
  },
  "message": "Ticket validated successfully"
}
```

#### GET /tickets/qr/{qrCode}
Obtener imagen QR de la entrada.

## 🔐 Autenticación

El sistema usa JWT (JSON Web Tokens) para autenticación.

### Header de Autenticación
```
Authorization: Bearer <jwt_token>
```

### Información del Token
- **Algoritmo:** HS256
- **Duración:** 24 horas
- **Claims:** userId, email

## 🗄️ Base de Datos

### Modelos Principales

#### Users
- `id` - ID único
- `email` - Email único
- `password` - Contraseña hasheada
- `name` - Nombre completo
- `created_at` - Fecha de creación

#### Events
- `id` - ID único
- `name` - Nombre del evento
- `description` - Descripción
- `date` - Fecha y hora
- `location` - Ubicación
- `created_by` - ID del usuario creador
- `is_active` - Estado activo/inactivo

#### TicketTypes
- `id` - ID único
- `event_id` - Referencia al evento
- `name` - Nombre del tipo (General, VIP, etc.)
- `price` - Precio
- `max_quantity` - Cantidad máxima (opcional)
- `current_quantity` - Cantidad actual vendida

#### Tickets
- `id` - ID único
- `event_id` - Referencia al evento
- `ticket_type_id` - Referencia al tipo de entrada
- `attendee_name` - Nombre del asistente
- `attendee_email` - Email del asistente
- `attendee_phone` - Teléfono del asistente
- `qr_code` - Código QR único
- `status` - Estado (VALID, USED, INVALID)
- `used_at` - Fecha de uso
- `used_by` - ID del usuario que validó

## 🔧 Configuración

### application.conf
```hocon
ktor {
    development = true
    deployment {
        port = 8080
    }
    application {
        modules = [ co.ticketcolombia.ApplicationKt.module ]
    }
}
```

### build.gradle.kts
Configuración de dependencias principales:
- Ktor Server
- PostgreSQL + Exposed ORM
- JWT Authentication
- ZXing para códigos QR
- Logback para logging

## 🧪 Pruebas

### Verificar Estado del Servidor
```bash
curl http://localhost:8080/health
```

### Probar Autenticación
```bash
# Registrar usuario
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ejemplo.com","password":"123456","name":"Test User"}'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ejemplo.com","password":"123456"}'
```

### Probar Creación de Evento
```bash
curl -X POST http://localhost:8080/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Evento Test",
    "description": "Descripción del evento",
    "date": "2024-12-31T20:00:00",
    "location": "Bogotá",
    "ticketTypes": [{"name": "General", "price": 50000}]
  }'
```

## 🐛 Solución de Problemas

### Error de Conexión a Base de Datos
```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status postgresql

# Verificar conexión
psql -h localhost -U ticketuser -d ticketcolombia
```

### Puerto 8080 en Uso
```bash
# Verificar qué proceso usa el puerto
sudo lsof -i :8080

# Cambiar puerto en application.conf
ktor.deployment.port = 8081
```

### Error de Permisos Gradle
```bash
# Dar permisos de ejecución
chmod +x gradlew
```

## 📊 Logs

Los logs se configuran con Logback y se escriben a consola por defecto.

### Niveles de Log
- **INFO** - Información general
- **WARN** - Advertencias
- **ERROR** - Errores

### Ver Logs en Tiempo Real
```bash
tail -f logs/application.log
```

## 🚀 Despliegue

### JAR Ejecutable
```bash
./gradlew shadowJar
java -jar build/libs/ticket-colombia-backend-1.0.0-all.jar
```

### Docker (Opcional)
```dockerfile
FROM openjdk:17-jdk-slim
COPY build/libs/ticket-colombia-backend-1.0.0-all.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

## 📈 Monitoreo

### Health Check
- **Endpoint:** `GET /health`
- **Response:** `{"status": "healthy"}`

### Métricas (Futuro)
- Número de eventos activos
- Entradas vendidas por día
- Usuarios registrados
- Tiempo de respuesta de API

---

Para más información, consultar el README principal del proyecto.
