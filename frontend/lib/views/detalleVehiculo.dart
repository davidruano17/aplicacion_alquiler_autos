import 'package:flutter/material.dart';
import '../controllers/alquiler_controller.dart';
import '../theme/app_colors.dart';
import 'medioPago.dart';

class DetalleVehiculoScreen extends StatefulWidget {
  final String imageUrl;
  final String marca;
  final String modelo;
  final String anio;
  final int disponibilidad;
  final int autoId;
  final dynamic precio;

  const DetalleVehiculoScreen({
    super.key,
    required this.imageUrl,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.disponibilidad,
    required this.autoId,
    this.precio,
  });

  @override
  State<DetalleVehiculoScreen> createState() => _DetalleVehiculoScreenState();
}

class _DetalleVehiculoScreenState extends State<DetalleVehiculoScreen> {
  final Color fondo = AppColors.fondo;
  final Color encabezado = AppColors.encabezado;
  final Color campos = AppColors.campos;
  final Color boton = AppColors.boton;
  final Color texto = AppColors.texto;

  bool disponible = true;
  bool cargando = false;
  String? metodoPagoSeleccionado;
  final AlquilerService alquilerService = AlquilerService();

  @override
  void initState() {
    super.initState();
    disponible = widget.disponibilidad == 1;
  }

  void alquilarVehiculo() async {
    setState(() {
      cargando = true;
    });

    final String fechaInicio = DateTime.now().toUtc().toIso8601String();
    final String fechaFin = DateTime.now()
        .toUtc()
        .add(const Duration(days: 7))
        .toIso8601String();

    print('Auto ID: ${widget.autoId}');
    print('Fecha inicio: $fechaInicio');
    print('Fecha fin: $fechaFin');

    try {
      final response = await alquilerService.registrarAlquiler(
        widget.autoId,
        fechaInicio,
        fechaFin,
        autoInfo: {
          'id': widget.autoId,
          'marca': widget.marca,
          'modelo': widget.modelo,
          'anio': widget.anio,
          'imagen': widget.imageUrl,
          'precio': widget.precio,
        },
      );

      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      print('Respuesta: $response');

      if (response['success']) {
        setState(() {
          disponible = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alquiler registrado con exito'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error al registrar alquiler: $e');
      if (!mounted) return;
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexion: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void confirmarAlquiler() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Alquiler'),
          content: Text(
            '¿Está seguro de que desea alquilar el ${widget.marca} ${widget.modelo} por 7 días?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                alquilarVehiculo();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void seleccionarMedioPago() async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const MedioPagoScreen()),
    );
    if (resultado != null && mounted) {
      setState(() {
        metodoPagoSeleccionado = resultado;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Método de pago seleccionado: $resultado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, disponible ? 1 : 0);
        }
      },
      child: Scaffold(
        backgroundColor: fondo,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, disponible ? 1 : 0),
          ),
          backgroundColor: encabezado,
          foregroundColor: Colors.white,
          title: Text('${widget.marca} ${widget.modelo}'),
        ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: campos,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://picsum.photos/330/200',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${widget.marca} ${widget.modelo}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Año: ${widget.anio}',
                  style: TextStyle(
                    fontSize: 18,
                    color: texto.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: disponible ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        disponible ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        disponible ? 'Disponible' : 'No disponible',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Precio: \$${widget.precio}/día',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: boton,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: seleccionarMedioPago,
                  icon: const Icon(Icons.payment),
                  label: Text(
                    metodoPagoSeleccionado == null
                        ? 'Seleccionar Medio de Pago'
                        : 'Pago: $metodoPagoSeleccionado',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: texto,
                    side: BorderSide(color: encabezado),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: disponible ? boton : Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (!disponible || cargando)
                      ? null
                      : () => confirmarAlquiler(),
                  icon: cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.directions_car),
                  label: Text(
                    disponible ? 'Solicitar alquiler' : 'No disponible',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
