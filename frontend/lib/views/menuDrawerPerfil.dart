import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/cliente_controller.dart';
import '../theme/app_colors.dart';
import 'loginScreen.dart';
import 'revisarAlquileres.dart';

class MenuDrawerPerfil extends StatefulWidget {
  const MenuDrawerPerfil({super.key});

  @override
  State<MenuDrawerPerfil> createState() => _MenuDrawerPerfilState();
}

class _MenuDrawerPerfilState extends State<MenuDrawerPerfil> {
  final Color fondo = AppColors.fondo;
  final Color encabezado = AppColors.encabezado;
  final Color campos = AppColors.campos;
  final Color boton = AppColors.boton;
  final Color texto = AppColors.texto;

  final ClienteService _clienteService = ClienteService();

  String nombre = 'Usuario';
  String correo = 'correo@ejemplo.com';
  String numLic = '123456789';
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatosPerfil();
  }

  void cargarDatosPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final correoGuardado = prefs.getString('correo');

    final perfil = await _clienteService.obtenerPerfil();

    if (mounted) {
      setState(() {
        if (perfil != null) {
          nombre = perfil['nombre'] ?? 'Usuario';
          correo = perfil['correo'] ?? (correoGuardado ?? 'correo@ejemplo.com');
          numLic = perfil['numLic'] ?? '123456789';
        } else if (correoGuardado != null) {
          correo = correoGuardado;
        }
        cargando = false;
      });
    }
  }

  void mostrarDialogoCambiarPassword() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Nueva contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña actualizada')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void cerrarSesion() async {
    await _clienteService.cerrarSesion();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: encabezado),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage('https://picsum.photos/330/200'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    correo,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.badge, color: encabezado),
              title: const Text('Número de licencia'),
              subtitle: Text(numLic),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: encabezado),
              title: const Text('Cambiar contraseña'),
              onTap: mostrarDialogoCambiarPassword,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.history, color: boton),
              title: const Text('Revisar alquileres'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RevisarAlquileresScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: cerrarSesion,
            ),
          ],
        ),
      ),
    );
  }
}
