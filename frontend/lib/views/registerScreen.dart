import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../theme/app_colors.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color fondo = AppColors.fondo;
  final Color encabezado = AppColors.encabezado;
  final Color campos = AppColors.campos;
  final Color boton = AppColors.boton;
  final Color texto = AppColors.texto;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _numLicController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllervalida = TextEditingController();
  final ClienteService clienteService = ClienteService();

  bool _isLoading = false;

  void registrarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text.trim();
    final correo = _correoController.text.trim();
    final numLic = _numLicController.text.trim();
    final password = _passwordController.text;
    final passwordvalida = _passwordControllervalida.text;

    if (password != passwordvalida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contrasenas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await clienteService.registrarCliente(
        nombre,
        correo,
        numLic,
        password,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso'),
            backgroundColor: Colors.green,
          ),
        );
        limpiarCampos();
        irLogin();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error en el registro: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en la conexion con el servidor'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void limpiarCampos() {
    setState(() {
      _nombreController.clear();
      _correoController.clear();
      _numLicController.clear();
      _passwordController.clear();
      _passwordControllervalida.clear();
    });
  }

  void irLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _numLicController.dispose();
    _passwordController.dispose();
    _passwordControllervalida.dispose();
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      size: 80,
                      color: encabezado,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Empecemos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: encabezado,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Crear una nueva cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: texto.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nombreController,
                      style: TextStyle(color: texto),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: campos,
                        labelText: 'Nombre completo',
                        labelStyle: TextStyle(color: texto),
                        prefixIcon: Icon(Icons.person, color: encabezado),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
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
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'El correo es obligatorio';
                        }
                        if (!valor.contains('@') || !valor.contains('.')) {
                          return 'Escribe un correo valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _numLicController,
                      style: TextStyle(color: texto),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: campos,
                        labelText: 'Número de licencia',
                        labelStyle: TextStyle(color: texto),
                        prefixIcon: Icon(Icons.badge, color: encabezado),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'El número de licencia es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
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
                      validator: (valor) => (valor == null || valor.length < 6)
                          ? 'Minimo 6 caracteres'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordControllervalida,
                      obscureText: true,
                      style: TextStyle(color: texto),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: campos,
                        labelText: 'Confirmar contraseña',
                        labelStyle: TextStyle(color: texto),
                        prefixIcon: Icon(Icons.lock_outline, color: encabezado),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Por favor confirma tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: _isLoading ? null : registrarCliente,
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
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes una cuenta?',
                          style: TextStyle(color: texto),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Iniciar sesión',
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
      ),
    );
  }
}
