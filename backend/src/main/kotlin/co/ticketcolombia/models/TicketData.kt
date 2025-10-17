package co.ticketcolombia.models

import kotlinx.serialization.Serializable

@Serializable
data class TicketData(
    val id: Int,
    val eventId: Int,
    val ticketTypeId: Int,
    val attendeeName: String,
    val attendeeEmail: String,
    val attendeePhone: String,
    val qrCode: String,
    val isUsed: Boolean,
    val status: String,
    val createdAt: String
)

@Serializable
data class TicketValidateRequest(
    val qrCode: String
)

@Serializable
data class TicketValidateResponse(
    val isValid: Boolean,
    val isUsed: Boolean = false,
    val message: String,
    val ticket: TicketData? = null
)
