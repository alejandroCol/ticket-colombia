import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/ticket_provider.dart';
import '../../models/event.dart';
import '../../models/ticket.dart';
import 'create_ticket_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketProvider>(context, listen: false).loadTickets(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.tryParse(widget.event.date);
    final formattedDate = dateTime != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(dateTime)
        : 'Fecha no válida';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Evento',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _InfoRow(
                    icon: Icons.description,
                    label: 'Descripción',
                    value: widget.event.description,
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoRow(
                    icon: Icons.location_on,
                    label: 'Ubicación',
                    value: widget.event.location,
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoRow(
                    icon: Icons.event,
                    label: 'Fecha y Hora',
                    value: formattedDate,
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoRow(
                    icon: Icons.confirmation_number,
                    label: 'Tipos de Entrada',
                    value: '${widget.event.ticketTypes.length} tipo(s)',
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Consumer<TicketProvider>(
              builder: (context, ticketProvider, child) {
                if (ticketProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (ticketProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar entradas',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ticketProvider.error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ticketProvider.clearError();
                            ticketProvider.loadTickets(widget.event.id);
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (ticketProvider.tickets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay entradas creadas',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crea entradas para este evento',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateTicketScreen(
                                  event: widget.event,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Crear Entrada'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Entradas (${ticketProvider.tickets.length})',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ticketProvider.loadTickets(widget.event.id);
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await ticketProvider.loadTickets(widget.event.id);
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: ticketProvider.tickets.length,
                          itemBuilder: (context, index) {
                            final ticket = ticketProvider.tickets[index];
                            return _TicketCard(ticket: ticket);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTicketScreen(
                event: widget.event,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Crear Entrada'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Ticket ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.tryParse(ticket.createdAt);
    final formattedDate = dateTime != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(dateTime)
        : 'Fecha no válida';

    Color statusColor;
    String statusText;
    
    switch (ticket.status) {
      case 'VALID':
        statusColor = Colors.green;
        statusText = 'Válida';
        break;
      case 'USED':
        statusColor = Colors.orange;
        statusText = 'Usada';
        break;
      case 'INVALID':
        statusColor = Colors.red;
        statusText = 'Inválida';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Desconocido';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(ticket.attendeeName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.attendeeEmail),
            Text(ticket.attendeePhone),
            Text('Creada: $formattedDate'),
            if (ticket.ticketType != null)
              Text('Tipo: ${ticket.ticketType!.name} - \$${ticket.ticketType!.price.toStringAsFixed(0)}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _TicketDetailDialog(ticket: ticket),
          );
        },
      ),
    );
  }
}

class _TicketDetailDialog extends StatelessWidget {
  final Ticket ticket;

  const _TicketDetailDialog({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalle de la Entrada'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailRow(label: 'Nombre', value: ticket.attendeeName),
            _DetailRow(label: 'Email', value: ticket.attendeeEmail),
            _DetailRow(label: 'Teléfono', value: ticket.attendeePhone),
            if (ticket.ticketType != null)
              _DetailRow(label: 'Tipo', value: ticket.ticketType!.name),
            if (ticket.ticketType != null)
              _DetailRow(label: 'Precio', value: '\$${ticket.ticketType!.price.toStringAsFixed(0)}'),
            _DetailRow(label: 'QR Code', value: ticket.qrCode),
            _DetailRow(label: 'Estado', value: ticket.status),
            _DetailRow(label: 'Creada', value: ticket.createdAt),
            if (ticket.usedAt != null)
              _DetailRow(label: 'Usada', value: ticket.usedAt!),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
