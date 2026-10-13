import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiConfig {
  // Cambia a true si quieres usar el servidor desplegado en Render
  static const bool useRenderBackend = false;

  // URL del backend en Render (proporcionada en la guia)
  static const String renderBaseUrl = 'https://bakendalquilerautos.onrender.com';

  // Obtiene la URL base adecuada segun la plataforma (Emulador Android usa 10.0.2.2)
  static String get baseUrl {
    if (useRenderBackend) {
      return renderBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      }
    } catch (_) {
      // Plataforma no soporta Platform.isAndroid
    }

    return 'http://localhost:3000';
  }
}
