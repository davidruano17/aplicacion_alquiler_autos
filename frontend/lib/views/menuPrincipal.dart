import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/autos_controller.dart';
import '../theme/app_colors.dart';
import 'detalleVehiculo.dart';
import 'menuDrawerPerfil.dart';
import 'revisarAlquileres.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final Color fondo = AppColors.fondo;
  final Color encabezado = AppColors.encabezado;
  final Color campos = AppColors.campos;
  final Color boton = AppColors.boton;
  final Color texto = AppColors.texto;

  final AutosController autosController = AutosController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de 15 autos con fotos reales de vehículos (Guía 03)
  List<Map<String, dynamic>> listaDeAutos = [
    {
      'id': 1,
      'imageUrl':
          'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600',
      'marca': 'Toyota',
      'modelo': 'Corolla',
      'anio': '2022',
      'disponibilidad': 1,
      'precio': 99.99,
    },
    {
      'id': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=600',
      'marca': 'Nissan',
      'modelo': 'Sentra',
      'anio': '2021',
      'disponibilidad': 1,
      'precio': 89.99,
    },
    {
      'id': 3,
      'imageUrl':
          'https://images.unsplash.com/photo-1584345604476-8ec5e12e42dd?w=600',
      'marca': 'Ford',
      'modelo': 'Mustang',
      'anio': '2023',
      'disponibilidad': 0,
      'precio': 199.99,
    },
    {
      'id': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=600',
      'marca': 'Chevrolet',
      'modelo': 'Camaro',
      'anio': '2020',
      'disponibilidad': 1,
      'precio': 150.00,
    },
    {
      'id': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600',
      'marca': 'Chevrolet',
      'modelo': 'Cruze',
      'anio': '2018',
      'disponibilidad': 1,
      'precio': 75.00,
    },
    {
      'id': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=600',
      'marca': 'Mazda',
      'modelo': 'CX-30',
      'anio': '2023',
      'disponibilidad': 1,
      'precio': 120.00,
    },
    {
      'id': 7,
      'imageUrl':
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=600',
      'marca': 'Renault',
      'modelo': 'Duster',
      'anio': '2022',
      'disponibilidad': 1,
      'precio': 85.00,
    },
    {
      'id': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=600',
      'marca': 'Hyundai',
      'modelo': 'Tucson',
      'anio': '2023',
      'disponibilidad': 1,
      'precio': 110.00,
    },
    {
      'id': 9,
      'imageUrl':
          'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?w=600',
      'marca': 'Kia',
      'modelo': 'Sportage',
      'anio': '2022',
      'disponibilidad': 1,
      'precio': 105.00,
    },
    {
      'id': 10,
      'imageUrl':
          'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=600',
      'marca': 'Volkswagen',
      'modelo': 'Golf',
      'anio': '2021',
      'disponibilidad': 1,
      'precio': 95.00,
    },
    {
      'id': 11,
      'imageUrl':
          'https://images.unsplash.com/photo-1590362891988-f77804703080?w=600',
      'marca': 'Honda',
      'modelo': 'Civic',
      'anio': '2022',
      'disponibilidad': 1,
      'precio': 90.00,
    },
    {
      'id': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=600',
      'marca': 'BMW',
      'modelo': 'Serie 3',
      'anio': '2023',
      'disponibilidad': 1,
      'precio': 210.00,
    },
    {
      'id': 13,
      'imageUrl':
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600',
      'marca': 'Mercedes-Benz',
      'modelo': 'Clase C',
      'anio': '2022',
      'disponibilidad': 1,
      'precio': 230.00,
    },
    {
      'id': 14,
      'imageUrl':
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=600',
      'marca': 'Audi',
      'modelo': 'A4',
      'anio': '2023',
      'disponibilidad': 1,
      'precio': 220.00,
    },
    {
      'id': 15,
      'imageUrl':
          'https://images.unsplash.com/photo-1506015391300-4802dc74de2e?w=600',
      'marca': 'Jeep',
      'modelo': 'Wrangler',
      'anio': '2021',
      'disponibilidad': 0,
      'precio': 180.00,
    },
  ];

  List<Map<String, dynamic>> listaFiltrada = [];
  bool isLoading = false;
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sincronizarDisponibilidadLocal();
    cargarAutos();
  }

  Future<void> _sincronizarDisponibilidadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final ocupadosRaw = prefs.getString('autos_ocupados') ?? '[]';
    final List<dynamic> ocupados = jsonDecode(ocupadosRaw);

    for (var auto in listaDeAutos) {
      if (ocupados.contains(auto['id'])) {
        auto['disponibilidad'] = 0;
      }
    }
    _filtrarAutos(_searchController.text);
  }

  void cargarAutos() async {
    try {
      final autos = await autosController.obtenerAutosDisponibles();
      if (!mounted) return;
      if (autos.isNotEmpty) {
        setState(() {
          listaDeAutos = autos;
        });
      }
    } catch (e) {
      print('Error al cargar autos desde API: $e');
    }
    await _sincronizarDisponibilidadLocal();
  }

  void _filtrarAutos(String consulta) {
    if (consulta.trim().isEmpty) {
      setState(() {
        listaFiltrada = List.from(listaDeAutos);
      });
    } else {
      setState(() {
        listaFiltrada = listaDeAutos.where((auto) {
          final marca = auto['marca']?.toString().toLowerCase() ?? '';
          final modelo = auto['modelo']?.toString().toLowerCase() ?? '';
          final query = consulta.toLowerCase();
          return marca.contains(query) || modelo.contains(query);
        }).toList();
      });
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RevisarAlquileresScreen(),
        ),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
        _sincronizarDisponibilidadLocal();
      });
    } else if (index == 2) {
      _scaffoldKey.currentState?.openDrawer();
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: fondo,
      drawer: const MenuDrawerPerfil(),
      appBar: AppBar(
        title: const Text('Alquiler de Vehículos'),
        backgroundColor: encabezado,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filtrarAutos,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: encabezado),
                hintText: 'Buscar vehículo...',
                hintStyle: TextStyle(color: texto.withValues(alpha: 0.7)),
                filled: true,
                fillColor: campos,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listaFiltrada.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay vehiculos disponibles',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: listaFiltrada.length,
                          itemBuilder: (BuildContext context, int index) {
                            final auto = listaFiltrada[index];
                            final bool disponible =
                                auto['disponibilidad'] == 1;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    auto['imageUrl'].toString(),
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.directions_car,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  '${auto['marca']} ${auto['modelo']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Año: ${auto['anio']} - Precio: \$${auto['precio']}/día',
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      disponible
                                          ? 'Disponible'
                                          : 'No disponible',
                                      style: TextStyle(
                                        color: disponible
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: boton,
                                  size: 18,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleVehiculoScreen(
                                        imageUrl: auto['imageUrl'],
                                        marca: auto['marca'],
                                        modelo: auto['modelo'],
                                        anio: auto['anio'].toString(),
                                        disponibilidad:
                                            auto['disponibilidad'] ?? 1,
                                        precio: auto['precio'],
                                        autoId: auto['id'] ?? 0,
                                      ),
                                    ),
                                  ).then((resultado) {
                                    if (resultado is int) {
                                      setState(() {
                                        auto['disponibilidad'] = resultado;
                                        _filtrarAutos(_searchController.text);
                                      });
                                    }
                                    _sincronizarDisponibilidadLocal();
                                    cargarAutos();
                                  });
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: boton,
        unselectedItemColor: texto.withValues(alpha: 0.6),
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}
