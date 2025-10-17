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
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter
import com.google.zxing.common.BitMatrix
import com.google.zxing.client.j2se.MatrixToImageWriter
import java.awt.Color
import java.awt.Graphics2D
import java.awt.image.BufferedImage
import java.io.ByteArrayOutputStream
import java.util.*
import javax.imageio.ImageIO

object EmailService {
    // Configuración de Resend - API Key válida
    private val resendApiKey = "re_NpMHqGuU_NuKJqwEpKRATj378NU8hTYUG"
    private val fromEmail = "onboarding@resend.dev"

    private val httpClient = HttpClient(CIO) {
        install(ContentNegotiation) {
            json(Json { ignoreUnknownKeys = true })
        }
    }

    @Serializable
    data class ResendEmailRequest(
        val from: String,
        val to: List<String>,
        val subject: String,
        val html: String,
        val attachments: List<ResendAttachment>? = null
    )

    @Serializable
    data class ResendAttachment(
        val filename: String,
        val content: String, // Base64 encoded
        val content_type: String = "application/pdf"
    )

    @Serializable
    data class ResendResponse(
        val id: String
    )

        private fun generateQRCodeImageBase64(qrCode: String): String {
            try {
                val qrCodeWriter = QRCodeWriter()
                val hints = mutableMapOf<EncodeHintType, Any>()
                hints[EncodeHintType.CHARACTER_SET] = "UTF-8"
                hints[EncodeHintType.MARGIN] = 1

                val bitMatrix: BitMatrix = qrCodeWriter.encode(qrCode, BarcodeFormat.QR_CODE, 200, 200, hints)

                // Usar MatrixToImageWriter para generar PNG directamente
                val baos = ByteArrayOutputStream()
                MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos)
                
                val imageBytes = baos.toByteArray()
                println("QR Image size: ${imageBytes.size} bytes (${imageBytes.size / 1024} KB)")

                return Base64.getEncoder().encodeToString(imageBytes)
            } catch (e: Exception) {
                println("Error generating QR code: ${e.message}")
                e.printStackTrace()
                return generateFallbackQRImageBase64()
            }
        }

        private fun generateCamouflagedQRImageBase64(qrCode: String): String {
            try {
                val qrCodeWriter = QRCodeWriter()
                val hints = mutableMapOf<EncodeHintType, Any>()
                hints[EncodeHintType.CHARACTER_SET] = "UTF-8"
                hints[EncodeHintType.MARGIN] = 2

                val bitMatrix: BitMatrix = qrCodeWriter.encode(qrCode, BarcodeFormat.QR_CODE, 180, 180, hints)

                // Crear una imagen más grande con fondo decorativo
                val finalSize = 250
                val image = BufferedImage(finalSize, finalSize, BufferedImage.TYPE_INT_RGB)
                val g2d = image.createGraphics()

                // Configurar anti-aliasing
                g2d.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING, java.awt.RenderingHints.VALUE_ANTIALIAS_ON)
                g2d.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION, java.awt.RenderingHints.VALUE_INTERPOLATION_BILINEAR)

                // Fondo degradado suave
                val gradient = java.awt.GradientPaint(
                    0f, 0f, Color(240, 248, 255),
                    finalSize.toFloat(), finalSize.toFloat(), Color(255, 250, 240)
                )
                g2d.paint = gradient
                g2d.fillRect(0, 0, finalSize, finalSize)

                // Agregar patrón decorativo sutil
                g2d.color = Color(230, 230, 230)
                for (i in 0..finalSize step 20) {
                    for (j in 0..finalSize step 20) {
                        if ((i + j) % 40 == 0) {
                            g2d.fillOval(i, j, 3, 3)
                        }
                    }
                }

                // Dibujar el QR en el centro con un marco
                val qrSize = 180
                val offset = (finalSize - qrSize) / 2
                
                // Marco decorativo
                g2d.color = Color(200, 200, 200)
                g2d.fillRoundRect(offset - 5, offset - 5, qrSize + 10, qrSize + 10, 10, 10)
                
                g2d.color = Color.WHITE
                g2d.fillRoundRect(offset - 3, offset - 3, qrSize + 6, qrSize + 6, 8, 8)

                // Dibujar el QR
                g2d.color = Color.BLACK
                val cellSize = qrSize / bitMatrix.width
                for (x in 0 until bitMatrix.width) {
                    for (y in 0 until bitMatrix.height) {
                        if (bitMatrix.get(x, y)) {
                            g2d.fillRect(
                                offset + x * cellSize,
                                offset + y * cellSize,
                                cellSize,
                                cellSize
                            )
                        }
                    }
                }

                // Agregar texto decorativo
                g2d.color = Color(100, 100, 100)
                g2d.font = java.awt.Font("Arial", java.awt.Font.PLAIN, 10)
                g2d.drawString("Ticket Colombia", 10, finalSize - 10)

                g2d.dispose()

                val baos = ByteArrayOutputStream()
                ImageIO.write(image, "PNG", baos)
                val imageBytes = baos.toByteArray()
                println("Camouflaged QR Image size: ${imageBytes.size} bytes (${imageBytes.size / 1024} KB)")

                return Base64.getEncoder().encodeToString(imageBytes)
            } catch (e: Exception) {
                println("Error generating camouflaged QR code: ${e.message}")
                e.printStackTrace()
                return generateFallbackQRImageBase64()
            }
        }

    private fun generateFallbackQRImageBase64(): String {
        val size = 150
        val image = BufferedImage(size, size, BufferedImage.TYPE_INT_RGB)
        val g2d: Graphics2D = image.createGraphics()

        g2d.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING, java.awt.RenderingHints.VALUE_ANTIALIAS_ON)

        g2d.color = Color.WHITE
        g2d.fillRect(0, 0, size, size)

        g2d.color = Color.BLACK
        val cellSize = 6
        val margin = 15

        for (x in 0..6) {
            for (y in 0..6) {
                if ((x < 2 || x > 4) && (y < 2 || y > 4)) {
                    g2d.fillRect(margin + x * cellSize, margin + y * cellSize, cellSize, cellSize)
                }
            }
        }

        g2d.dispose()

        val baos = ByteArrayOutputStream()
        val writer = ImageIO.getImageWritersByFormatName("PNG").next()
        val imageOutputStream = ImageIO.createImageOutputStream(baos)
        writer.output = imageOutputStream

        val writeParam = writer.defaultWriteParam
        writeParam.compressionMode = javax.imageio.ImageWriteParam.MODE_EXPLICIT
        writeParam.compressionQuality = 0.8f

        writer.write(null, javax.imageio.IIOImage(image, null, null), writeParam)
        writer.dispose()
        imageOutputStream.close()

        val imageBytes = baos.toByteArray()
        println("Fallback QR Image size: ${imageBytes.size} bytes (${imageBytes.size / 1024} KB)")

        return Base64.getEncoder().encodeToString(imageBytes)
    }

           suspend fun sendTicketEmail(attendeeEmail: String, attendeeName: String, qrCode: String, eventName: String, ticketType: String = "General", price: Double = 0.0) {
               try {
                   println("Sending email to: $attendeeEmail")
                
                // Generar PDF del ticket
                val pdfBytes = SimplePDFService.generateTicketPDF(
                    attendeeName = attendeeName,
                    attendeeEmail = attendeeEmail,
                    qrCode = qrCode,
                    eventName = eventName,
                    ticketType = ticketType,
                    price = price
                )
                
                val pdfBase64 = Base64.getEncoder().encodeToString(pdfBytes)
                println("PDF Ticket size: ${pdfBytes.size} bytes (${pdfBytes.size / 1024} KB)")
            
                   val htmlContent = """
                       <!DOCTYPE html>
                       <html>
                       <head>
                           <meta charset="UTF-8">
                           <meta name="viewport" content="width=device-width, initial-scale=1.0">
                           <title>Tu entrada - Ticket Colombia</title>
                       </head>
                       <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f5f5f5;">
                           <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f5f5f5;">
                               <tr>
                                   <td align="center" style="padding: 20px 0;">
                                       <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" style="background-color: #ffffff; border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
                                           <!-- Header -->
                                           <tr>
                                               <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
                                                   <h1 style="margin: 0; font-size: 28px; font-weight: bold;">🎫 Ticket Colombia</h1>
                                                   <p style="margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;">Tu entrada está lista</p>
                                               </td>
                                           </tr>
                                           
                                           <!-- Content -->
                                           <tr>
                                               <td style="padding: 30px;">
                                                   <h2 style="color: #333; margin: 0 0 20px 0; font-size: 24px;">¡Hola $attendeeName!</h2>
                                                   <p style="color: #666; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                                                       Tu entrada para <strong style="color: #667eea;">$eventName</strong> ha sido creada exitosamente.
                                                   </p>

                                                   <!-- Simple PDF Info -->
                                                   <div style="background: #f8f9fa; border-radius: 8px; padding: 20px; margin: 20px 0; border-left: 4px solid #667eea;">
                                                       <p style="color: #555; font-size: 16px; margin: 0 0 10px 0;">
                                                           📎 <strong>Tu ticket está adjunto a este email</strong>
                                                       </p>
                                                       <p style="color: #777; font-size: 14px; margin: 0;">
                                                           Descarga el PDF y muéstralo en la entrada del evento
                                                       </p>
                                                   </div>

                                                   <!-- Instructions -->
                                                   <div style="background: #e8f4fd; border-radius: 8px; padding: 20px; margin: 20px 0;">
                                                       <h4 style="color: #1976d2; margin: 0 0 15px 0; font-size: 18px;">📱 Instrucciones importantes:</h4>
                                                       <ul style="color: #555; margin: 0; padding-left: 20px; font-size: 14px; line-height: 1.6;">
                                                           <li style="margin-bottom: 8px;">Descarga el PDF adjunto</li>
                                                           <li style="margin-bottom: 8px;">Guarda el PDF en tu teléfono</li>
                                                           <li style="margin-bottom: 8px;">Presenta el PDF en la entrada del evento</li>
                                                           <li style="margin-bottom: 8px;">Llega con tiempo al evento</li>
                                                           <li style="margin-bottom: 0;">No compartas tu entrada con otros</li>
                                                       </ul>
                                                   </div>

                                                   <!-- Footer -->
                                                   <p style="color: #666; font-size: 14px; text-align: center; margin: 30px 0 0 0;">
                                                       Gracias por elegir <strong style="color: #667eea;">Ticket Colombia</strong> 🎉
                                                   </p>
                                               </td>
                                           </tr>
                                       </table>
                                   </td>
                               </tr>
                           </table>
                       </body>
                       </html>
                   """.trimIndent()

                   val request = ResendEmailRequest(
                       from = "Ticket Colombia <$fromEmail>",
                       to = listOf(attendeeEmail),
                       subject = "Tu entrada para $eventName - Ticket Colombia (Para: $attendeeName)",
                    html = htmlContent,
                    attachments = listOf(
                        ResendAttachment(
                            filename = "Ticket_${attendeeName.replace(" ", "_")}.pdf",
                            content = pdfBase64,
                            content_type = "application/pdf"
                        )
                    )
                )

                val response = httpClient.post("https://api.resend.com/emails") {
                    headers {
                        append("Authorization", "Bearer $resendApiKey")
                        append(HttpHeaders.ContentType, "application/json")
                    }
                    setBody(request)
                }

                if (response.status.isSuccess()) {
                    val result: ResendResponse = response.body()
                    println("Email sent successfully to $attendeeEmail with ID: ${result.id}")
                } else {
                    val errorBody: String = response.body()
                    println("Failed to send email: ${response.status}")
                    println("Error response: $errorBody")
                }
            } catch (e: Exception) {
                println("Failed to send email: ${e.message}")
                e.printStackTrace()
            }
        }
}