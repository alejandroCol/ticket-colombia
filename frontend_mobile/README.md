# 🎫 Ticket Colombia - App Móvil

Aplicación móvil desarrollada en Flutter para el control de acceso mediante escáner QR.

## 🚀 Inicio Rápido

### Prerrequisitos
- Flutter 3.0+
- Dart 3.0+
- Dispositivo Android/iOS o Emulador
- Backend ejecutándose en puerto 8080

### Instalación

```bash
# Navegar al directorio
cd frontend_mobile/

# Instalar dependencias
flutter pub get

# Ejecutar en dispositivo/emulador
flutter run
```

## 📱 Funcionalidades

### Autenticación
- **Login de controladores** - Acceso para personal autorizado
- **Gestión de sesión** - Token JWT automático
- **Información de usuario** - Datos del controlador logueado

### Escáner QR
- **Cámara integrada** - Escáner de códigos QR en tiempo real
- **Overlay visual** - Guía para apuntar correctamente
- **Detección automática** - Validación instantánea al escanear

### Validación de Entradas
- **Pantalla de resultado** - Verde (válida) / Roja (inválida)
- **Información detallada** - Datos completos del asistente
- **Estado de entrada** - Válida, usada, o inválida
- **Registro de uso** - Marca automática como usada

## 🏗️ Arquitectura

### Estructura de Carpetas
```
lib/
├── main.dart                 # Punto de entrada
├── models/                   # Modelos de datos
│   ├── user.dart
│   └── ticket.dart
├── services/                 # Servicios API
│   └── api_service.dart
├── providers/                # Gestión de estado
│   ├── auth_provider.dart
│   └── ticket_provider.dart
├── screens/                  # Pantallas de la app
│   ├── splash_screen.dart
│   ├── auth/
│   │   └── login_screen.dart
│   └── scanner/
│       ├── scanner_screen.dart
│       └── validation_result_screen.dart
└── widgets/                  # Componentes reutilizables
```

### Gestión de Estado (Provider)
- **AuthProvider** - Autenticación y usuario actual
- **TicketProvider** - Validación de entradas

### Servicios
- **ApiService** - Cliente HTTP para comunicación con backend
- **MobileScanner** - Escáner de códigos QR
- **SharedPreferences** - Almacenamiento local de tokens

## 📷 Configuración del Escáner

### Permisos Requeridos

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Esta app necesita acceso a la cámara para escanear códigos QR</string>
```

### Configuración de Red

#### Para Android Emulator
```dart
// En lib/services/api_service.dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

#### Para iOS Simulator
```dart
// Cambiar a:
static const String baseUrl = 'http://localhost:8080';
```

#### Para Dispositivo Físico
```dart
// Usar IP local de tu máquina:
static const String baseUrl = 'http://192.168.1.100:8080';
```

## 🎨 Diseño UI

### Material 3
- **Color primario:** #1976D2 (Azul institucional)
- **Pantallas de resultado:**
  - **Verde:** Entrada válida
  - **Roja:** Entrada inválida/ya usada
- **Interfaz minimalista** - Enfocada en funcionalidad

### Flujo Visual
1. **Splash Screen** - Logo y carga inicial
2. **Login** - Formulario simple y limpio
3. **Escáner** - Cámara con overlay de guía
4. **Resultado** - Pantalla de validación con colores

## 📋 Flujo de Usuario

### 1. Autenticación
1. Usuario accede a la aplicación
2. Pantalla de splash verifica autenticación
3. Redirige a login si no está autenticado
4. Formulario de login con validaciones
5. Almacenamiento automático del token JWT

### 2. Escaneo y Validación
1. Pantalla principal con escáner activo
2. Usuario apunta cámara al código QR
3. Detección automática del código
4. Validación con el backend
5. Pantalla de resultado con información

### 3. Gestión de Resultados
1. **Entrada Válida:**
   - Pantalla verde con información del asistente
   - Datos del evento y tipo de entrada
   - Botón para continuar escaneando

2. **Entrada Inválida:**
   - Pantalla roja con mensaje de error
   - Información sobre el problema
   - Botón para intentar otra vez

## 🧪 Pruebas

### Pruebas Manuales

#### Autenticación
1. **Login:**
   - Usar credenciales de controlador
   - Verificar redirección a escáner
   - Verificar información en menú

#### Escáner QR
1. **Escaneo Exitoso:**
   - Generar QR desde app web
   - Escanear con app móvil
   - Verificar pantalla verde
   - Verificar información correcta

2. **QR Ya Usado:**
   - Escanear QR usado previamente
   - Verificar pantalla roja
   - Verificar mensaje de error

3. **QR Inválido:**
   - Escanear código inexistente
   - Verificar pantalla roja
   - Verificar mensaje de error

### Pruebas de Integración
```bash
# 1. Backend ejecutándose
curl http://localhost:8080/health

# 2. Crear entrada en app web
# 3. Ejecutar app móvil
flutter run

# 4. Login con credenciales
# 5. Escanear QR generado
# 6. Verificar validación
```

## 🐛 Solución de Problemas

### Error de Cámara
```bash
# Verificar permisos en dispositivo
# Android: Configuración > Aplicaciones > Ticket Colombia > Permisos
# iOS: Configuración > Privacidad > Cámara > Ticket Colombia
```

### Error de Conexión API
```dart
// Verificar URL en api_service.dart
static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator
// static const String baseUrl = 'http://localhost:8080'; // iOS simulator
```

### Error de Dependencias
```bash
# Limpiar cache y reinstalar
flutter clean
flutter pub get

# Reinstalar dependencias nativas
cd ios && pod install && cd ..
```

### Error de Build
```bash
# Verificar versión de Flutter
flutter --version

# Limpiar build
flutter clean
flutter pub get
flutter run
```

## 📱 Compatibilidad

### Dispositivos Soportados
- **Android:** 5.0+ (API 21+)
- **iOS:** 11.0+

### Características Requeridas
- **Cámara:** Requerida para escáner QR
- **Internet:** Requerida para validación
- **Almacenamiento:** Para tokens JWT

### Resoluciones Optimizadas
- **Phone:** 375x667, 414x896, 360x640
- **Tablet:** 768x1024, 1024x768

## 🚀 Despliegue

### Build para Producción

#### Android APK
```bash
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle
```bash
flutter build appbundle --release
# AAB en: build/app/outputs/bundle/release/app-release.aab
```

#### iOS
```bash
flutter build ios --release
# Abrir Xcode y archivar para App Store
```

### Configurar para Producción
```dart
// Cambiar URL de API para producción
static const String baseUrl = 'https://api.ticketcolombia.com';
```

### Firmas Digitales

#### Android (android/app/build.gradle)
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

#### iOS (ios/Runner.xcodeproj)
- Configurar certificados en Xcode
- Configurar provisioning profiles

## 📊 Rendimiento

### Optimizaciones Implementadas
- **Lazy loading** - Carga bajo demanda
- **Provider state management** - Gestión eficiente de estado
- **Camera optimization** - Uso eficiente de cámara
- **Network caching** - Cache de tokens JWT

### Métricas Objetivo
- **Tiempo de inicio:** < 2 segundos
- **Tiempo de escaneo:** < 1 segundo
- **Tiempo de validación:** < 2 segundos
- **Tamaño de APK:** < 25MB

## 🔄 Actualizaciones Futuras

### Funcionalidades Planificadas
- [ ] **Modo offline** - Cache de validaciones
- [ ] **Historial de escaneos** - Registro local
- [ ] **Estadísticas** - Métricas de uso
- [ ] **Múltiples usuarios** - Switch de controladores
- [ ] **Notificaciones push** - Alertas del sistema
- [ ] **Biometría** - Login con huella/face

### Mejoras Técnicas
- [ ] **Testing automatizado** - Unit/Widget tests
- [ ] **CI/CD pipeline** - GitHub Actions
- [ ] **Crash reporting** - Firebase Crashlytics
- [ ] **Analytics** - Firebase Analytics
- [ ] **Performance monitoring** - Métricas detalladas

## 📋 Checklist de Despliegue

### Pre-despliegue
- [ ] Verificar permisos de cámara
- [ ] Configurar URL de producción
- [ ] Probar en dispositivos reales
- [ ] Verificar conectividad de red
- [ ] Validar flujo completo

### Post-despliegue
- [ ] Monitorear crashes
- [ ] Verificar métricas de uso
- [ ] Revisar feedback de usuarios
- [ ] Actualizar documentación

---

Para más información, consultar el README principal del proyecto.
