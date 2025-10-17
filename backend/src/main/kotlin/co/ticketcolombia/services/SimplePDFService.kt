package co.ticketcolombia.services

import org.apache.pdfbox.pdmodel.PDDocument
import org.apache.pdfbox.pdmodel.PDPage
import org.apache.pdfbox.pdmodel.PDPageContentStream
import org.apache.pdfbox.pdmodel.font.PDType1Font
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject
import org.apache.pdfbox.pdmodel.common.PDRectangle
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter
import com.google.zxing.common.BitMatrix
import com.google.zxing.client.j2se.MatrixToImageWriter
import java.awt.image.BufferedImage
import java.io.ByteArrayOutputStream
import java.util.*

object SimplePDFService {
    
    fun generateTicketPDF(attendeeName: String, attendeeEmail: String, qrCode: String, eventName: String, ticketType: String, price: Double): ByteArray {
        val document = PDDocument()
        
        try {
            val page = PDPage(PDRectangle.A4)
            document.addPage(page)
            
            val contentStream = PDPageContentStream(document, page)
            
            // Header
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 24f)
            contentStream.newLineAtOffset(50f, 750f)
            contentStream.showText("TICKET COLOMBIA")
            contentStream.endText()
            
            // Event Info
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 18f)
            contentStream.newLineAtOffset(50f, 700f)
            contentStream.showText("EVENTO: $eventName")
            contentStream.endText()
            
            // Attendee Info
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA, 12f)
            contentStream.newLineAtOffset(50f, 650f)
            contentStream.showText("Nombre: $attendeeName")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("Email: $attendeeEmail")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("Tipo: $ticketType")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("Precio: $${String.format("%.2f", price)}")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("Código: $qrCode")
            contentStream.endText()
            
            // QR Code
            val qrImage = generateQRCodeImage(qrCode)
            val qrImageXObject = PDImageXObject.createFromByteArray(document, qrImage, "QRCode")
            contentStream.drawImage(qrImageXObject, 200f, 500f, 150f, 150f)
            
            // Instructions
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 14f)
            contentStream.newLineAtOffset(50f, 400f)
            contentStream.showText("INSTRUCCIONES:")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA, 12f)
            contentStream.newLineAtOffset(50f, 380f)
            contentStream.showText("• Presenta este PDF en la entrada del evento")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("• Llega con tiempo al evento")
            contentStream.endText()
            
            contentStream.beginText()
            contentStream.newLineAtOffset(0f, -20f)
            contentStream.showText("• No compartas tu entrada con otros")
            contentStream.endText()
            
            // Footer
            contentStream.beginText()
            contentStream.setFont(PDType1Font.HELVETICA_OBLIQUE, 10f)
            contentStream.newLineAtOffset(50f, 300f)
            contentStream.showText("Gracias por elegir Ticket Colombia")
            contentStream.endText()
            
            contentStream.close()
            
            val outputStream = ByteArrayOutputStream()
            document.save(outputStream)
            return outputStream.toByteArray()
            
        } finally {
            document.close()
        }
    }
    
    private fun generateQRCodeImage(qrCode: String): ByteArray {
        try {
            val qrCodeWriter = QRCodeWriter()
            val hints = mutableMapOf<EncodeHintType, Any>()
            hints[EncodeHintType.CHARACTER_SET] = "UTF-8"
            hints[EncodeHintType.MARGIN] = 1

            val bitMatrix: BitMatrix = qrCodeWriter.encode(qrCode, BarcodeFormat.QR_CODE, 200, 200, hints)

            val baos = ByteArrayOutputStream()
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos)
            
            return baos.toByteArray()
        } catch (e: Exception) {
            println("Error generating QR code for PDF: ${e.message}")
            e.printStackTrace()
            return generateFallbackQRImage()
        }
    }
    
    private fun generateFallbackQRImage(): ByteArray {
        val size = 200
        val image = BufferedImage(size, size, BufferedImage.TYPE_INT_RGB)
        val g2d = image.createGraphics()

        g2d.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING, java.awt.RenderingHints.VALUE_ANTIALIAS_ON)

        g2d.color = java.awt.Color.WHITE
        g2d.fillRect(0, 0, size, size)

        g2d.color = java.awt.Color.BLACK
        val cellSize = 6
        val margin = 20

        for (x in 0..6) {
            for (y in 0..6) {
                if ((x < 2 || x > 4) && (y < 2 || y > 4)) {
                    g2d.fillRect(margin + x * cellSize, margin + y * cellSize, cellSize, cellSize)
                }
            }
        }

        g2d.dispose()

        val baos = ByteArrayOutputStream()
        javax.imageio.ImageIO.write(image, "PNG", baos)
        return baos.toByteArray()
    }
}
