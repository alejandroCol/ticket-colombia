package co.ticketcolombia.models

import kotlinx.serialization.Serializable

@Serializable
data class EventCreateRequest(
    val name: String,
    val description: String,
    val date: String,
    val location: String,
    val ticketTypes: List<TicketTypeCreateRequest>
)

@Serializable
data class TicketTypeCreateRequest(
    val name: String,
    val price: Double,
    val description: String? = null,
    val maxQuantity: Int? = null
)
