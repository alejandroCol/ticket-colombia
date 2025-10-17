import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ticket_provider.dart';
import '../../models/event.dart';
import '../../models/ticket.dart';

class CreateTicketScreen extends StatefulWidget {
  final Event event;

  const CreateTicketScreen({super.key, required this.event});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  TicketType? _selectedTicketType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _createTicket() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTicketType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de entrada')),
      );
      return;
    }

    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    
    final request = TicketCreateRequest(
      eventId: widget.event.id,
      ticketTypeId: _selectedTicketType!.id,
      attendeeName: _nameController.text.trim(),
      attendeeEmail: _emailController.text.trim(),
      attendeePhone: _phoneController.text.trim(),
    );

    print('Creating ticket with request: ${request.toJson()}');
    final success = await ticketProvider.createTicket(request);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrada creada exitosamente')),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear entrada: ${ticketProvider.error ?? 'Error desconocido'}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Entrada'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                      Text(
                        widget.event.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.event.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de Entrada',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (widget.event.ticketTypes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hay tipos de entrada disponibles',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Este evento no tiene tipos de entrada configurados',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.event.ticketTypes.length,
                          itemBuilder: (context, index) {
                            final ticketType = widget.event.ticketTypes[index];
                            final isSelected = _selectedTicketType?.id == ticketType.id;
                            final isAvailable = ticketType.maxQuantity == null || 
                                ticketType.currentQuantity < ticketType.maxQuantity!;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isSelected ? Colors.blue[50] : null,
                              child: RadioListTile<TicketType>(
                                title: Text(ticketType.name),
                                subtitle: Text(
                                  '\$${ticketType.price.toStringAsFixed(0)}${ticketType.maxQuantity != null ? ' - ${ticketType.maxQuantity! - ticketType.currentQuantity} disponibles' : ' - Ilimitado'}',
                                ),
                                value: ticketType,
                                groupValue: _selectedTicketType,
                                onChanged: isAvailable ? (value) {
                                  setState(() {
                                    _selectedTicketType = value;
                                  });
                                } : null,
                                secondary: isAvailable 
                                    ? null 
                                    : const Icon(Icons.block, color: Colors.red),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información del Asistente',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El correo es requerido';
                          }
                          if (!value.contains('@')) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Número de teléfono',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El teléfono es requerido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Consumer<TicketProvider>(
                builder: (context, ticketProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (ticketProvider.isLoading || widget.event.ticketTypes.isEmpty) 
                          ? null 
                          : _createTicket,
                      child: ticketProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Crear Entrada'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
