import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../theme/app_colors.dart';
import 'menuPrincipal.dart';
import 'registerScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color fondo = AppColors.fondo;
  final Color encabezado = AppColors.encabezado;
  final Color campos = AppColors.campos;
  final Color boton = AppColors.boton;
  final Color texto = AppColors.texto;

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ClienteService clienteService = ClienteService();

  bool _isLoading = false;

  void iniciarSesion() async {
    final correo = _correoController.text.trim();
    final password = _passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await clienteService.loginCliente(correo, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesion exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['mensaje'] ?? 'Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_pin,
                    size: 80,
                    color: encabezado,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: encabezado,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicia sesión para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: texto.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: texto),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: campos,
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(color: texto),
                      prefixIcon: Icon(Icons.email, color: encabezado),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: texto),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: campos,
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: texto),
                      prefixIcon: Icon(Icons.lock, color: encabezado),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: boton,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: texto),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Función de recuperación en desarrollo'),
                            ),
                          );
                        },
                        child: Text(
                          'Recuperar',
                          style: TextStyle(
                            color: encabezado,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(color: texto),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: encabezado,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
