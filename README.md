# Sistema de Alquiler de Autos (ADSO - SENA)

Este proyecto implementa la solución completa para el sistema de **Alquiler de Autos**, compuesta por un backend REST en Node.js y una aplicación móvil frontend en Flutter que consume la API.

---

## 📁 Estructura del Proyecto

```
aplicacion_movil/
├── backend/                  # API REST con Node.js, Express y Sequelize (ESM)
│   ├── config/
│   │   └── config.cjs        # Configuración para Neon y Sequelize-CLI
│   ├── migrations/           # Migraciones de base de datos
│   ├── src/
│   │   ├── controllers/      # Controladores (cliente, auto, alquiler)
│   │   ├── middlewares/      # Auth JWT, validaciones y errores
│   │   ├── models/           # Modelos Sequelize y asociaciones
│   │   ├── routes/           # Rutas públicas y protegidas
│   │   ├── app.js            # Servidor Express y CORS
│   │   └── server.js         # Inicio del servidor
│   ├── seed.js               # Script para poblar 15 vehículos iniciales
│   ├── .env                  # Variables de entorno
│   └── package.json
│
├── frontend/                 # Aplicación Móvil en Flutter (Patrón MVC)
│   ├── lib/
│   │   ├── config/
│   │   │   └── api_config.dart     # Configuración de URLs (Local / Emulador / Render)
│   │   ├── controllers/            # ClienteService, AutosController, AlquilerService
│   │   ├── theme/
│   │   │   └── app_colors.dart     # Paleta de colores oficial
│   │   ├── views/                  # Vistas completas
│   │   │   ├── loginScreen.dart
│   │   │   ├── registerScreen.dart
│   │   │   ├── menuPrincipal.dart
│   │   │   ├── detalleVehiculo.dart
│   │   │   ├── medioPago.dart
│   │   │   ├── menuDrawerPerfil.dart
│   │   │   └── revisarAlquileres.dart
│   │   └── main.dart
│   └── pubspec.yaml
└── README.md
```

---

## 🚀 1. Puesta en Marcha del Backend

### Requisitos:
- Node.js v18+
- npm

### Pasos:
1. Navega a la carpeta `backend`:
   ```bash
   cd backend
   ```
2. Instala dependencias:
   ```bash
   npm install
   ```
3. Configuración de base de datos (`.env`):
   - Por defecto incluye soporte local automático o puedes colocar tu URL de Neon PostgreSQL:
     ```env
     DATABASE_URL=postgresql://usuario:clave@host.neon.tech/base?sslmode=require
     PORT=3000
     JWT_SECRET=super_secreto_para_alquiler_de_autos_seguro_2026_jwt
     ```
4. Poblar datos de prueba (15 vehículos iniciales):
   ```bash
   node seed.js
   ```
5. Iniciar el servidor:
   ```bash
   npm run dev
   # o
   npm start
   ```
   El servidor estará disponible en `http://localhost:3000`.

---

## 📱 2. Puesta en Marcha del Frontend (Flutter)

### Requisitos:
- Flutter SDK 3.x+
- Android Studio / Emulador o Navegador Web / Windows Desktop

### Pasos:
1. Navega a la carpeta `frontend`:
   ```bash
   cd frontend
   ```
2. Obtén las dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```
   > **Nota sobre la red:** En `lib/config/api_config.dart`:
   > - En emulador Android se conecta automáticamente a `http://10.0.2.2:3000`.
   > - En Windows / Web a `http://localhost:3000`.
   > - Para usar el backend alojado en Render, cambia `useRenderBackend = true`.

---

## 📡 3. Endpoints de la API

### Clientes
- `POST /api/clientes/registro`: Registro de clientes con contraseña cifrada (bcrypt).
- `POST /api/clientes/login`: Inicio de sesión y entrega de token JWT (expira en 2h).
- `GET /api/clientes/perfil`: Datos del usuario autenticado (Protegida con Bearer Token).

### Autos
- `GET /api/autos`: Catálogo completo de vehículos.
- `GET /api/autos/disponibles`: Vehículos disponibles (`disponibilidad = 1`).
- `GET /api/autos/:id`: Detalle de un vehículo por ID.
- `POST /api/autos`: Registrar auto (Protegida).
- `PUT /api/autos/:id`: Modificar auto (Protegida).
- `DELETE /api/autos/:id`: Baja lógica (`disponibilidad = 0`, Protegida).

### Alquiler
- `POST /api/alquiler`: Registrar alquiler (Protegida, asocia cliente mediante token).
- `GET /api/alquiler/historial`: Historial de alquileres del cliente con el Auto anidado (Protegida).
- `PUT /api/alquiler/devolver/:id`: Finalizar alquiler y liberar auto (Protegida).
