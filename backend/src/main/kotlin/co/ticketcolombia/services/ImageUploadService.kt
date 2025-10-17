package co.ticketcolombia.services

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.util.*

object ImageUploadService {
    // Cloudinary credentials (free tier)
    private val cloudName = "ticketcolombia"
    private val apiKey = "your_api_key_here" // You'll need to get this from Cloudinary
    private val apiSecret = "your_api_secret_here" // You'll need to get this from Cloudinary
    
    private val httpClient = HttpClient(CIO) {
        install(ContentNegotiation) {
            json()
        }
    }

    @Serializable
    data class CloudinaryResponse(
        val public_id: String,
        val secure_url: String,
        val url: String
    )

    /**
     * Uploads a Base64 image to Cloudinary and returns the public URL
     */
    suspend fun uploadQRImage(base64Image: String, qrCode: String): String? {
        return try {
            // For now, let's use a simple approach with a public image hosting service
            // We'll use imgur.com API which is free and doesn't require authentication for small images
            uploadToImgur(base64Image, qrCode)
        } catch (e: Exception) {
            println("Error uploading image: ${e.message}")
            e.printStackTrace()
            null
        }
    }

    private suspend fun uploadToImgur(base64Image: String, qrCode: String): String? {
        return try {
            val response = httpClient.post("https://api.imgur.com/3/image") {
                headers {
                    append(HttpHeaders.Authorization, "Client-ID 546c25a59c58ad7") // Public client ID for imgur
                    append(HttpHeaders.ContentType, "application/json")
                }
                setBody("""{"image":"$base64Image","title":"QR Code - $qrCode","description":"QR Code for Ticket Colombia"}""")
            }

            if (response.status.isSuccess()) {
                val result = response.body<Map<String, Any>>()
                val data = result["data"] as? Map<String, Any>
                val link = data?.get("link") as? String
                println("Image uploaded successfully: $link")
                link
            } else {
                println("Failed to upload to Imgur: ${response.status}")
                null
            }
        } catch (e: Exception) {
            println("Error uploading to Imgur: ${e.message}")
            null
        }
    }

    /**
     * Alternative: Upload to a simple file hosting service
     * This creates a temporary public URL for the QR image
     */
    suspend fun uploadToSimpleHosting(base64Image: String, qrCode: String): String? {
        return try {
            // For development, we'll create a simple data URL that works in most email clients
            // This is not ideal for production but works for testing
            "data:image/png;base64,$base64Image"
        } catch (e: Exception) {
            println("Error creating data URL: ${e.message}")
            null
        }
    }
}
