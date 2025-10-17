package co.ticketcolombia.models

import kotlinx.serialization.Serializable

@Serializable
data class ApiResponse(
    val message: String,
    val success: Boolean = true,
    val data: String? = null
)
