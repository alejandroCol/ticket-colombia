package co.ticketcolombia.models

import kotlinx.serialization.Serializable

@Serializable
data class TicketCreateRequest(
    val eventId: Int,
    val ticketTypeId: Int,
    val attendeeName: String,
    val attendeeEmail: String,
    val attendeePhone: String
)
