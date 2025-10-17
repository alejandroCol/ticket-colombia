# 🚀 Instrucciones de Ejecución - Ticket Colombia

Guía paso a paso para ejecutar el sistema completo de Ticket Colombia.

## 📋 Prerrequisitos

### Software Necesario
- **Java 17+** - Para el backend
- **PostgreSQL 13+** - Base de datos
- **Flutter 3.0+** - Para frontend web y móvil
- **Gradle 8.3+** - Build tool del backend

### Verificar Instalaciones
```bash
# Verificar Java
java -version

# Verificar PostgreSQL
psql --version

# Verificar Flutter
flutter --version

# Verificar Gradle
./gradlew --version
```

## 🗄️ Paso 1: Configurar Base de Datos

### Instalar PostgreSQL
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# macOS (con Homebrew)
brew install postgresql
brew services start postgresql

# Windows
# Descargar desde: https://www.postgresql.org/download/windows/
```

### Crear Base de Datos y Usuario
```bash
# Acceder a PostgreSQL
sudo -u postgres psql

# Crear base de datos
CREATE DATABASE ticketcolombia;

# Crear usuario
CREATE USER ticketuser WITH PASSWORD 'ticketpass';

# Dar permisos
GRANT ALL PRIVILEGES ON DATABASE ticketcolombia TO ticketuser;

# Salir
\q
```

### Verificar Conexión
```bash
# Probar conexión
psql -h localhost -U ticketuser -d ticketcolombia
# Contraseña: ticketpass
```

## 🖥️ Paso 2: Ejecutar Backend

### Navegar al Directorio
```bash
cd "/Users/alejandro/Documents/Ticket Colombia/backend"
```

### Configurar Variables de Entorno (Opcional)
```bash
# En el archivo .env o exportar
export DATABASE_URL=jdbc:postgresql://localhost:5432/ticketcolombia
export DATABASE_USER=ticketuser
export DATABASE_PASSWORD=ticketpass
```

### Ejecutar el Servidor
```bash
# Opción 1: Ejecutar directamente
./gradlew run

# Opción 2: Compilar y ejecutar
./gradlew build
java -jar build/libs/ticket-colombia-backend-1.0.0.jar
```

### Verificar que el Backend Esté Funcionando
```bash
# Probar endpoint de salud
curl http://localhost:8080/health

# Respuesta esperada: {"status":"healthy"}
```

El backend estará disponible en: `http://localhost:8080`

## 🌐 Paso 3: Ejecutar Flutter Web

### Navegar al Directorio
```bash
cd "/Users/alejandro/Documents/Ticket Colombia/frontend_web"
```

### Instalar Dependencias
```bash
flutter pub get
```

### Ejecutar en Modo Web
```bash
# Ejecutar en puerto específico
flutter run -d web-server --web-port 3000

# O ejecutar con puerto por defecto
flutter run -d web-server
```

### Verificar Aplicación Web
- Abrir navegador en: `http://localhost:3000`
- Debería mostrar la pantalla de splash de Ticket Colombia

## 📱 Paso 4: Ejecutar Flutter Mobile

### Navegar al Directorio
```bash
cd "/Users/alejandro/Documents/Ticket Colombia/frontend_mobile"
```

### Instalar Dependencias
```bash
flutter pub get
```

### Configurar para Dispositivo/Emulador

#### Para Android Emulator
```bash
# Verificar emuladores disponibles
flutter devices

# Ejecutar en emulador Android
flutter run -d android

# O especificar emulador específico
flutter run -d "emulator-5554"
```

#### Para iOS Simulator
```bash
# Ejecutar en simulador iOS
flutter run -d ios

# O especificar simulador específico
flutter run -d "iPhone 14"
```

#### Para Dispositivo Físico
```bash
# Conectar dispositivo USB
# Habilitar depuración USB en Android
# O conectar iPhone y confiar en la computadora

# Ejecutar en dispositivo
flutter run
```

## 🧪 Paso 5: Probar Flujo Completo

### 1. Registrar Usuario en Web
1. Abrir `http://localhost:3000`
2. Hacer clic en "¿No tienes cuenta? Regístrate"
3. Completar formulario de registro
4. Verificar redirección al dashboard

### 2. Crear Evento
1. En el dashboard, hacer clic en "Crear Evento"
2. Completar información del evento:
   - Nombre: "Concierto Test"
   - Descripción: "Evento de prueba"
   - Fecha: Seleccionar fecha futura
   - Ubicación: "Bogotá"
3. Agregar tipo de entrada:
   - Nombre: "General"
   - Precio: 50000
   - Cantidad: 100
4. Hacer clic en "Crear Evento"

### 3. Crear Entrada
1. En el dashboard, hacer clic en el evento creado
2. Hacer clic en "Crear Entrada"
3. Seleccionar tipo "General"
4. Completar datos del asistente:
   - Nombre: "Juan Pérez"
   - Email: "juan@ejemplo.com"
   - Teléfono: "3001234567"
5. Hacer clic en "Crear Entrada"
6. **¡IMPORTANTE!** Anotar el código QR generado

### 4. Probar en App Móvil
1. Abrir la app móvil
2. Iniciar sesión con las mismas credenciales del paso 1
3. La app mostrará la pantalla del escáner
4. Apuntar la cámara al código QR de la entrada creada
5. Verificar que aparezca pantalla verde con información del asistente

### 5. Probar Entrada Ya Usada
1. Intentar escanear el mismo QR otra vez
2. Verificar que aparezca pantalla roja indicando "Ticket already used"

## 🔧 Configuraciones Adicionales

### Cambiar Puerto del Backend
```bash
# En backend/gradle.properties
ktor.deployment.port=8081

# O en backend/src/main/resources/application.conf
ktor {
    deployment {
        port = 8081
    }
}
```

### Cambiar Puerto de Flutter Web
```bash
flutter run -d web-server --web-port 4000
```

### Configurar Red para App Móvil

#### Para Android Emulator
```dart
// En frontend_mobile/lib/services/api_service.dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

#### Para iOS Simulator
```dart
static const String baseUrl = 'http://localhost:8080';
```

#### Para Dispositivo Físico
```dart
// Usar la IP local de tu computadora
static const String baseUrl = 'http://192.168.1.100:8080';
```

## 🐛 Solución de Problemas Comunes

### Error: Puerto 8080 en uso
```bash
# Verificar qué proceso usa el puerto
sudo lsof -i :8080

# Matar proceso si es necesario
sudo kill -9 <PID>

# O cambiar puerto en configuración
```

### Error: No se puede conectar a PostgreSQL
```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status postgresql

# Reiniciar PostgreSQL
sudo systemctl restart postgresql

# Verificar conexión
psql -h localhost -U ticketuser -d ticketcolombia
```

### Error: Flutter no encuentra dispositivos
```bash
# Verificar dispositivos disponibles
flutter devices

# Para Android: Verificar que ADB esté funcionando
adb devices

# Para iOS: Verificar que Xcode esté instalado
xcode-select --print-path
```

### Error: App móvil no conecta al backend
1. Verificar que el backend esté ejecutándose
2. Verificar URL en `api_service.dart`
3. Verificar conectividad de red
4. Probar con `curl` desde el dispositivo/emulador

### Error: Permisos de cámara en app móvil
```bash
# Android: Verificar permisos en AndroidManifest.xml
# iOS: Verificar permisos en Info.plist

# En dispositivo:
# Android: Configuración > Aplicaciones > Ticket Colombia > Permisos
# iOS: Configuración > Privacidad > Cámara > Ticket Colombia
```

## 📊 Verificación del Sistema

### Endpoints del Backend
```bash
# Health check
curl http://localhost:8080/health

# API info
curl http://localhost:8080/

# Probar registro
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ejemplo.com","password":"123456","name":"Test User"}'
```

### Logs del Backend
```bash
# Ver logs en tiempo real
tail -f logs/application.log

# O en consola donde se ejecutó ./gradlew run
```

### Logs de Flutter
```bash
# Ver logs de Flutter Web
# En la consola del navegador (F12)

# Ver logs de Flutter Mobile
flutter logs
```

## 🎯 Checklist de Verificación

- [ ] PostgreSQL instalado y corriendo
- [ ] Base de datos `ticketcolombia` creada
- [ ] Backend ejecutándose en puerto 8080
- [ ] Flutter Web ejecutándose en puerto 3000
- [ ] Flutter Mobile ejecutándose en dispositivo/emulador
- [ ] Usuario registrado exitosamente
- [ ] Evento creado exitosamente
- [ ] Entrada creada exitosamente
- [ ] QR escaneado exitosamente en app móvil
- [ ] Validación mostrando pantalla verde
- [ ] Entrada marcada como usada al escanear segunda vez

## 📞 Soporte

Si encuentras problemas:

1. **Verificar logs** - Revisar consola del backend y Flutter
2. **Verificar conectividad** - Probar endpoints con curl
3. **Verificar permisos** - Base de datos, cámara, red
4. **Revisar documentación** - README específicos de cada componente

---

¡El sistema Ticket Colombia debería estar funcionando completamente! 🎉
