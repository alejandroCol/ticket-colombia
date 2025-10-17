import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ticket.dart';

class ValidationResultScreen extends StatelessWidget {
  final TicketValidationResponse? response;
  final String qrCode;
  final VoidCallback onBack;

  const ValidationResultScreen({
    super.key,
    required this.response,
    required this.qrCode,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = response?.isValid ?? false;
    final ticket = response?.ticket;
    final message = response?.message ?? 'Error desconocido';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de Validación'),
        backgroundColor: isValid ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            onBack();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isValid
                ? [Colors.green.shade50, Colors.green.shade100]
                : [Colors.red.shade50, Colors.red.shade100],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isValid ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isValid ? Icons.check_circle : Icons.cancel,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Status message
                Text(
                  isValid ? 'ENTRADA VÁLIDA' : 'ENTRADA INVÁLIDA',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isValid ? Colors.green[800] : Colors.red[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Ticket details (if valid)
                if (isValid && ticket != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalles de la Entrada',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _DetailRow(
                          icon: Icons.person,
                          label: 'Asistente',
                          value: ticket.attendeeName,
                        ),
                        const SizedBox(height: 12),
                        
                        _DetailRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: ticket.attendeeEmail,
                        ),
                        const SizedBox(height: 12),
                        
                        _DetailRow(
                          icon: Icons.phone,
                          label: 'Teléfono',
                          value: ticket.attendeePhone,
                        ),
                        const SizedBox(height: 12),
                        
                        if (ticket.event != null) ...[
                          _DetailRow(
                            icon: Icons.event,
                            label: 'Evento',
                            value: ticket.event!.name,
                          ),
                          const SizedBox(height: 12),
                        ],
                        
                        if (ticket.ticketType != null) ...[
                          _DetailRow(
                            icon: Icons.confirmation_number,
                            label: 'Tipo',
                            value: ticket.ticketType!.name,
                          ),
                          const SizedBox(height: 12),
                          
                          _DetailRow(
                            icon: Icons.attach_money,
                            label: 'Precio',
                            value: '\$${ticket.ticketType!.price.toStringAsFixed(0)}',
                          ),
                          const SizedBox(height: 12),
                        ],
                        
                        _DetailRow(
                          icon: Icons.qr_code,
                          label: 'Código QR',
                          value: qrCode,
                        ),
                        const SizedBox(height: 12),
                        
                        _DetailRow(
                          icon: Icons.access_time,
                          label: 'Validada',
                          value: _formatDateTime(DateTime.now()),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onBack();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: isValid ? Colors.green : Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Escanear Otra',
                          style: TextStyle(
                            color: isValid ? Colors.green[800] : Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onBack();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid ? Colors.green : Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
