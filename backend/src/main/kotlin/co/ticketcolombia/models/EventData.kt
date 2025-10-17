package co.ticketcolombia.models

import kotlinx.serialization.Serializable

@Serializable
data class EventData(
    val id: Int,
    val name: String,
    val description: String,
    val date: String,
    val location: String,
    val ticketTypes: List<TicketTypeData>,
    val createdAt: String
)

@Serializable
data class TicketTypeData(
    val id: Int,
    val name: String,
    val price: Double,
    val description: String? = null,
    val maxQuantity: Int? = null
)
