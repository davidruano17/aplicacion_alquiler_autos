import 'package:flutter/material.dart';
import '../controllers/alquiler_controller.dart';
import '../theme/app_colors.dart';

class RevisarAlquileresScreen extends StatefulWidget {
  const RevisarAlquileresScreen({super.key});

  @override
  State<RevisarAlquileresScreen> createState() =>
      _RevisarAlquileresScreenState();
}

class _RevisarAlquileresScreenState extends State<RevisarAlquileresScreen> {
  final AlquilerService alquilerService = AlquilerService();
  List<dynamic> alquileres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarAlquileres();
  }

  void cargarAlquileres() async {
    try {
      final data = await alquilerService.obtenerHistorial();
      if (!mounted) return;
      setState(() {
        alquileres = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar historial: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void devolverVehiculo(int idAlquiler, {int? autoId}) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Devolver Vehículo'),
        content: const Text(
          '¿Desea finalizar el alquiler y devolver este vehículo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final res =
          await alquilerService.devolverVehiculo(idAlquiler, autoId: autoId);
      if (!mounted) return;
      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['mensaje'] ?? 'Vehiculo devuelto'),
            backgroundColor: Colors.green,
          ),
        );
        cargarAlquileres(); // Refrescar lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['mensaje'] ?? 'Error al devolver'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Alquileres'),
        backgroundColor: AppColors.encabezado,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alquileres.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes alquileres registrados',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: alquileres.length,
                  itemBuilder: (context, index) {
                    final item = alquileres[index];
                    final auto = item['Auto'];
                    final bool esActivo = item['estado'] == 'activo';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                auto?['imagen'] ?? 'https://picsum.photos/200',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://picsum.photos/200',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${auto?['marca'] ?? ''} ${auto?['modelo'] ?? ''}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Año: ${auto?['anio'] ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Inicio: ${item['fechaInicio']?.toString().split('T').first ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Fin: ${item['fechaFin']?.toString().split('T').first ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: esActivo
                                              ? Colors.orange.shade100
                                              : Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Estado: ${item['estado']}',
                                          style: TextStyle(
                                            color: esActivo
                                                ? Colors.orange.shade800
                                                : Colors.green.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      if (esActivo)
                                        TextButton.icon(
                                          onPressed: () => devolverVehiculo(
                                            item['id'],
                                            autoId: item['autoId'],
                                          ),
                                          icon: const Icon(
                                            Icons.assignment_return,
                                            size: 16,
                                          ),
                                          label: const Text('Devolver'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
