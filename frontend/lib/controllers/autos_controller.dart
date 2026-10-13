import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AutosController {
  // URL base para los endpoints de autos
  final String baseUrl = '${ApiConfig.baseUrl}/api/autos';

  // GET /api/autos — trae todos los vehiculos
  Future<List<Map<String, dynamic>>> obtenerAutosDisponibles() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map<Map<String, dynamic>>((auto) {
          final imagen = auto['imagen']?.toString().trim();

          return {
            'id': auto['id'],
            'marca': auto['marca'],
            'modelo': auto['modelo'],
            'anio': auto['anio'],
            'disponibilidad': auto['disponibilidad'] is int
                ? auto['disponibilidad']
                : int.tryParse(auto['disponibilidad'].toString()) ?? 1,
            'imageUrl': (imagen != null &&
                    imagen.isNotEmpty &&
                    (imagen.startsWith('http://') ||
                        imagen.startsWith('https://')))
                ? imagen
                : 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600',
            'precio': auto['valorAlquiler'],
          };
        }).toList();
      } else {
        throw Exception('Error al obtener vehiculos');
      }
    } catch (e) {
      print('Error en obtenerAutosDisponibles: $e');
      return [];
    }
  }
}
