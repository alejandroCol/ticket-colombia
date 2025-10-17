package co.ticketcolombia

import co.ticketcolombia.models.*
import co.ticketcolombia.storage.DataStorage
import co.ticketcolombia.services.EmailService
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.cors.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.response.*
import io.ktor.server.request.*
import io.ktor.server.routing.*
import io.ktor.http.*
import kotlinx.serialization.json.Json
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import kotlin.random.Random

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {
    install(CORS) {
        anyHost()
        allowHeader(HttpHeaders.ContentType)
        allowHeader(HttpHeaders.Authorization)
        allowMethod(HttpMethod.Options)
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
    }
    
    install(ContentNegotiation) {
        json()
    }
    
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respond(HttpStatusCode.InternalServerError, mapOf("error" to cause.message))
        }
    }
    
    routing {
        // Auth routes
        route("/auth") {
            post("/register") {
                try {
                    val request = call.receive<UserCreateRequest>()
                    val user = User(
                        id = Random.nextInt(1000, 9999),
                        username = request.username,
                        email = request.email,
                        createdAt = LocalDateTime.now().toString()
                    )
                    call.respond(HttpStatusCode.Created, ApiResponse(
                        message = "User registered successfully",
                        data = Json.encodeToString(User.serializer(), user)
                    ))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, ApiResponse(
                        message = "Registration failed: ${e.message}",
                        success = false
                    ))
                }
            }
            
            post("/login") {
                try {
                    val request = call.receive<UserLoginRequest>()
                    val user = User(
                        id = Random.nextInt(1000, 9999),
                        username = "testuser",
                        email = request.email,
                        createdAt = LocalDateTime.now().toString()
                    )
                    call.respond(HttpStatusCode.OK, ApiResponse(
                        message = "Login successful",
                        data = Json.encodeToString(User.serializer(), user)
                    ))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, ApiResponse(
                        message = "Login failed: ${e.message}",
                        success = false
                    ))
                }
            }
            
            get("/me") {
                call.respond(HttpStatusCode.OK, ApiResponse(message = "User info endpoint ready"))
            }
        }
        
        // Event routes
        route("/events") {
            get {
                try {
                    val events = DataStorage.getAllEvents()
                    call.respond(HttpStatusCode.OK, events)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, ApiResponse(
                        message = "Failed to retrieve events: ${e.message}",
                        success = false
                    ))
                }
            }
            
            post {
                try {
                    val request = call.receive<EventCreateRequest>()
                    val event = EventData(
                        id = Random.nextInt(1000, 9999),
                        name = request.name,
                        description = request.description,
                        date = request.date,
                        location = request.location,
                        ticketTypes = request.ticketTypes.map { ticketTypeRequest ->
                            TicketTypeData(
                                id = Random.nextInt(1000, 9999),
                                name = ticketTypeRequest.name,
                                price = ticketTypeRequest.price,
                                description = ticketTypeRequest.description,
                                maxQuantity = ticketTypeRequest.maxQuantity
                            )
                        },
                        createdAt = LocalDateTime.now().toString()
                    )
                    DataStorage.saveEvent(event)
                    call.respond(HttpStatusCode.Created, ApiResponse(
                        message = "Event created successfully",
                        data = event.id.toString()
                    ))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, ApiResponse(
                        message = "Event creation failed: ${e.message}",
                        success = false
                    ))
                }
            }
            
            get("/{id}") {
                try {
                    val id = call.parameters["id"]?.toIntOrNull()
                    if (id == null) {
                        call.respond(HttpStatusCode.BadRequest, ApiResponse(message = "Invalid event ID", success = false))
                        return@get
                    }
                    val event = DataStorage.getEventById(id)
                    if (event != null) {
                        call.respond(HttpStatusCode.OK, event)
                    } else {
                        call.respond(HttpStatusCode.NotFound, ApiResponse(message = "Event not found", success = false))
                    }
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, ApiResponse(
                        message = "Failed to retrieve event: ${e.message}",
                        success = false
                    ))
                }
            }
        }
        
        // Ticket routes
        route("/tickets") {
            post {
                try {
                    val request = call.receive<TicketCreateRequest>()
                    val qrCode = "QR-${System.currentTimeMillis()}-${Random.nextInt(1000, 9999)}"
                    val ticket = TicketData(
                        id = Random.nextInt(1000, 9999),
                        eventId = request.eventId,
                        ticketTypeId = request.ticketTypeId,
                        attendeeName = request.attendeeName,
                        attendeeEmail = request.attendeeEmail,
                        attendeePhone = request.attendeePhone,
                        qrCode = qrCode,
                        isUsed = false,
                        status = "VALID",
                        createdAt = LocalDateTime.now().toString()
                    )
                    DataStorage.saveTicket(ticket)
                    
                    // Send email with PDF
                    EmailService.sendTicketEmail(
                        attendeeEmail = ticket.attendeeEmail,
                        attendeeName = ticket.attendeeName,
                        qrCode = ticket.qrCode,
                        eventName = "Evento Test", // TODO: Get from event
                        ticketType = "General", // TODO: Get from ticket type
                        price = 0.0 // TODO: Get from ticket type
                    )
                    
                    call.respond(HttpStatusCode.Created, ticket)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, ApiResponse(
                        message = "Ticket creation failed: ${e.message}",
                        success = false
                    ))
                }
            }
            
            get {
                try {
                    val eventId = call.request.queryParameters["eventId"]?.toIntOrNull()
                    if (eventId == null) {
                        call.respond(HttpStatusCode.BadRequest, ApiResponse(message = "Event ID is required", success = false))
                        return@get
                    }
                    val tickets = DataStorage.getTicketsForEvent(eventId)
                    call.respond(HttpStatusCode.OK, tickets)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, ApiResponse(
                        message = "Failed to retrieve tickets: ${e.message}",
                        success = false
                    ))
                }
            }
            
            post("/validate") {
                try {
                    val request = call.receive<TicketValidateRequest>()
                    val ticket = DataStorage.getTicketByQrCode(request.qrCode)
                    
                    if (ticket == null) {
                        call.respond(HttpStatusCode.NotFound, TicketValidateResponse(
                            isValid = false,
                            message = "Ticket not found."
                        ))
                        return@post
                    }
                    
                    if (ticket.isUsed) {
                        call.respond(HttpStatusCode.OK, TicketValidateResponse(
                            isValid = false,
                            message = "Ticket already used.",
                            ticket = ticket
                        ))
                        return@post
                    }
                    
                    DataStorage.markTicketAsUsed(request.qrCode)
                    val updatedTicket = ticket.copy(isUsed = true, status = "USED")
                    
                    call.respond(HttpStatusCode.OK, TicketValidateResponse(
                        isValid = true,
                        message = "Ticket validated successfully.",
                        ticket = updatedTicket
                    ))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, ApiResponse(
                        message = "Ticket validation failed: ${e.message}",
                        success = false
                    ))
                }
            }
        }
    }
}