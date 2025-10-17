# 🎫 Ticket Colombia - Frontend Web

Aplicación web desarrollada en Flutter para la gestión de eventos y entradas.

## 🚀 Inicio Rápido

### Prerrequisitos
- Flutter 3.0+
- Dart 3.0+
- Backend ejecutándose en puerto 8080

### Instalación

```bash
# Navegar al directorio
cd frontend_web/

# Instalar dependencias
flutter pub get

# Ejecutar en modo web
flutter run -d web-server --web-port 3000
```

La aplicación estará disponible en: `http://localhost:3000`

## 📱 Funcionalidades

### Autenticación
- **Registro de usuarios** - Crear cuenta nueva
- **Inicio de sesión** - Login con email/contraseña
- **Gestión de sesión** - Token JWT automático

### Dashboard
- **Lista de eventos** - Vista de todos los eventos creados
- **Estado de eventos** - Activo/Inactivo
- **Estadísticas** - Número de tipos de entrada

### Gestión de Eventos
- **Crear evento** - Formulario completo con validaciones
- **Información básica** - Nombre, descripción, fecha, ubicación
- **Tipos de entrada** - Múltiples tipos con precios y límites
- **Vista detallada** - Información completa del evento

### Gestión de Entradas
- **Crear entrada** - Formulario para asistentes
- **Información del asistente** - Nombre, email, teléfono
- **Generación QR** - Código único automático
- **Lista de entradas** - Vista con estados y filtros

## 🏗️ Arquitectura

### Estructura de Carpetas
```
lib/
├── main.dart                 # Punto de entrada
├── models/                   # Modelos de datos
│   ├── user.dart
│   ├── event.dart
│   └── ticket.dart
├── services/                 # Servicios API
│   └── api_service.dart
├── providers/                # Gestión de estado
│   ├── auth_provider.dart
│   ├── event_provider.dart
│   └── ticket_provider.dart
├── screens/                  # Pantallas de la app
│   ├── splash_screen.dart
│   ├── auth/
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   └── events/
│       ├── create_event_screen.dart
│       ├── event_detail_screen.dart
│       └── create_ticket_screen.dart
└── widgets/                  # Componentes reutilizables
    └── event_card.dart
```

### Gestión de Estado (Provider)
- **AuthProvider** - Autenticación y usuario actual
- **EventProvider** - Lista y gestión de eventos
- **TicketProvider** - Lista y gestión de entradas

### Servicios
- **ApiService** - Cliente HTTP para comunicación con backend
- **SharedPreferences** - Almacenamiento local de tokens

## 🎨 Diseño UI

### Material 3
- **Color primario:** #1976D2 (Azul institucional)
- **Tema claro** - Optimizado para productividad
- **Componentes modernos** - Cards, botones, formularios

### Responsive Design
- **Grid adaptativo** - 3 columnas en desktop, 1 en móvil
- **Formularios optimizados** - Validación en tiempo real
- **Navegación intuitiva** - Flujo claro entre pantallas

## 🔧 Configuración

### API Endpoint
```dart
// En lib/services/api_service.dart
static const String baseUrl = 'http://localhost:8080';
```

### Rutas
```dart
// En main.dart
routes: {
  '/login': (context) => const LoginScreen(),
  '/dashboard': (context) => const DashboardScreen(),
}
```

## 📋 Flujo de Usuario

### 1. Autenticación
1. Usuario accede a la aplicación
2. Pantalla de splash verifica autenticación
3. Redirige a login si no está autenticado
4. Formulario de registro/login con validaciones
5. Almacenamiento automático del token JWT

### 2. Gestión de Eventos
1. Dashboard muestra eventos del usuario
2. Botón "Crear Evento" abre formulario
3. Formulario con información básica
4. Agregar tipos de entrada dinámicamente
5. Validación y creación del evento

### 3. Gestión de Entradas
1. Desde evento específico, botón "Crear Entrada"
2. Selección de tipo de entrada
3. Formulario con datos del asistente
4. Generación automática de QR
5. Lista de entradas con estados

## 🧪 Pruebas

### Pruebas Manuales

#### Autenticación
1. **Registro:**
   - Completar formulario con datos válidos
   - Verificar redirección a dashboard
   - Verificar token almacenado

2. **Login:**
   - Usar credenciales existentes
   - Verificar redirección a dashboard
   - Verificar información de usuario en header

#### Gestión de Eventos
1. **Crear Evento:**
   - Llenar todos los campos requeridos
   - Agregar al menos un tipo de entrada
   - Verificar creación exitosa
   - Verificar aparición en dashboard

2. **Ver Evento:**
   - Hacer clic en tarjeta de evento
   - Verificar información completa
   - Verificar tipos de entrada

#### Gestión de Entradas
1. **Crear Entrada:**
   - Seleccionar tipo de entrada
   - Completar datos del asistente
   - Verificar creación exitosa
   - Verificar aparición en lista

2. **Lista de Entradas:**
   - Verificar información completa
   - Verificar estados (Válida/Usada)
   - Verificar QR code único

### Pruebas de Integración
```bash
# Verificar que el backend esté corriendo
curl http://localhost:8080/health

# Ejecutar Flutter Web
flutter run -d web-server --web-port 3000

# Probar flujo completo:
# 1. Registro → 2. Crear evento → 3. Crear entrada → 4. Verificar en app móvil
```

## 🐛 Solución de Problemas

### Error de Conexión API
```dart
// Verificar URL en api_service.dart
static const String baseUrl = 'http://localhost:8080';

// Verificar que el backend esté corriendo
curl http://localhost:8080/health
```

### Error de CORS
- El backend incluye configuración CORS
- Verificar que el backend esté ejecutándose

### Error de Dependencias
```bash
# Limpiar cache y reinstalar
flutter clean
flutter pub get
```

### Error de Compilación Web
```bash
# Verificar versión de Flutter
flutter --version

# Habilitar web (si no está habilitado)
flutter config --enable-web
```

## 📱 Compatibilidad

### Navegadores Soportados
- **Chrome** 90+ (Recomendado)
- **Firefox** 88+
- **Safari** 14+
- **Edge** 90+

### Resoluciones
- **Desktop:** 1920x1080, 1366x768
- **Tablet:** 1024x768, 768x1024
- **Mobile:** 375x667, 414x896

## 🚀 Despliegue

### Build para Producción
```bash
# Generar build web
flutter build web

# Los archivos estarán en build/web/
```

### Configurar para Producción
```dart
// Cambiar URL de API para producción
static const String baseUrl = 'https://api.ticketcolombia.com';
```

### Servidor Web
```bash
# Usar cualquier servidor web estático
# Ejemplo con Python:
cd build/web
python -m http.server 8080

# Ejemplo con Node.js:
npx serve build/web -p 8080
```

## 📊 Rendimiento

### Optimizaciones Implementadas
- **Lazy loading** - Carga bajo demanda
- **Provider state management** - Gestión eficiente de estado
- **Image optimization** - QR codes optimizados
- **Form validation** - Validación en tiempo real

### Métricas Objetivo
- **Tiempo de carga inicial:** < 3 segundos
- **Tiempo de respuesta API:** < 500ms
- **Bundle size:** < 2MB

## 🔄 Actualizaciones Futuras

### Funcionalidades Planificadas
- [ ] **Dashboard con estadísticas** - Gráficos y métricas
- [ ] **Exportación de reportes** - PDF/Excel
- [ ] **Notificaciones push** - Web Push API
- [ ] **Modo offline** - Service Workers
- [ ] **Temas personalizables** - Dark/Light mode
- [ ] **Multi-idioma** - i18n support

### Mejoras Técnicas
- [ ] **Testing automatizado** - Unit/Widget tests
- [ ] **CI/CD pipeline** - GitHub Actions
- [ ] **PWA support** - Progressive Web App
- [ ] **Performance monitoring** - Analytics

---

Para más información, consultar el README principal del proyecto.
