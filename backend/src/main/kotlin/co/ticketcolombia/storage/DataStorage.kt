package co.ticketcolombia.storage

import co.ticketcolombia.models.EventData
import co.ticketcolombia.models.TicketData
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths

object DataStorage {
    private val dataFile = File("data.json")
    private val json = Json { ignoreUnknownKeys = true }
    
    private var events = mutableListOf<EventData>()
    private var tickets = mutableListOf<TicketData>()
    
    init {
        loadData()
    }
    
    private fun loadData() {
        if (dataFile.exists()) {
            try {
                val content = dataFile.readText()
                val data = json.decodeFromString<DataContainer>(content)
                events = data.events.toMutableList()
                tickets = data.tickets.toMutableList()
            } catch (e: Exception) {
                println("Error loading data: ${e.message}")
                events = mutableListOf()
                tickets = mutableListOf()
            }
        }
    }
    
    private fun saveData() {
        try {
            val data = DataContainer(events, tickets)
            val content = json.encodeToString(data)
            dataFile.writeText(content)
        } catch (e: Exception) {
            println("Error saving data: ${e.message}")
        }
    }
    
    fun getAllEvents(): List<EventData> = events.toList()
    
    fun getEventById(id: Int): EventData? = events.find { it.id == id }
    
    fun saveEvent(event: EventData) {
        val existingIndex = events.indexOfFirst { it.id == event.id }
        if (existingIndex >= 0) {
            events[existingIndex] = event
        } else {
            events.add(event)
        }
        saveData()
    }
    
    fun getTicketsForEvent(eventId: Int): List<TicketData> = 
        tickets.filter { it.eventId == eventId }
    
    fun getTicketByQrCode(qrCode: String): TicketData? = 
        tickets.find { it.qrCode == qrCode }
    
    fun saveTicket(ticket: TicketData) {
        val existingIndex = tickets.indexOfFirst { it.id == ticket.id }
        if (existingIndex >= 0) {
            tickets[existingIndex] = ticket
        } else {
            tickets.add(ticket)
        }
        saveData()
    }
    
    fun markTicketAsUsed(qrCode: String) {
        val ticket = tickets.find { it.qrCode == qrCode }
        if (ticket != null) {
            val updatedTicket = ticket.copy(isUsed = true, status = "USED")
            val index = tickets.indexOf(ticket)
            tickets[index] = updatedTicket
            saveData()
        }
    }
}

@kotlinx.serialization.Serializable
private data class DataContainer(
    val events: List<EventData>,
    val tickets: List<TicketData>
)