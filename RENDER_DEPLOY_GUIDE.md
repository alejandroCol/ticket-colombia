# 🚀 Guía de Deploy en Render.com

## **Paso 1: Preparar el Repositorio**

### 1.1 Crear repositorio en GitHub
```bash
# En tu terminal local
cd "/Users/alejandro/Documents/Ticket Colombia"
git init
git add .
git commit -m "Initial commit - Ticket Colombia MVP"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/ticket-colombia.git
git push -u origin main
```

### 1.2 Estructura del repositorio
```
ticket-colombia/
├── backend/
│   ├── build.gradle.kts
│   ├── render.yaml
│   ├── build.sh
│   └── src/
├── frontend_web/
│   ├── pubspec.yaml
│   ├── render.yaml
│   └── lib/
└── README.md
```

## **Paso 2: Configurar Render.com**

### 2.1 Crear cuenta en Render
1. Ve a [render.com](https://render.com)
2. Regístrate con GitHub
3. Conecta tu cuenta de GitHub

### 2.2 Crear Base de Datos PostgreSQL
1. En Render Dashboard → "New +" → "PostgreSQL"
2. Nombre: `ticketcolombia-db`
3. Plan: Free
4. Región: Oregon (US West)
5. Crear base de datos
6. **IMPORTANTE**: Copia la "External Database URL"

### 2.3 Crear Backend Service
1. En Render Dashboard → "New +" → "Web Service"
2. Conecta tu repositorio GitHub
3. Configuración:
   - **Name**: `ticketcolombia-backend`
   - **Environment**: `Kotlin`
   - **Build Command**: `cd backend && ./gradlew build`
   - **Start Command**: `cd backend && ./gradlew run`
   - **Plan**: Free

### 2.4 Variables de Entorno del Backend
En la sección "Environment Variables" del backend:
```
JWT_SECRET=tu-clave-secreta-super-segura-2024
JWT_ISSUER=ticketcolombia
JWT_AUDIENCE=ticketcolombia-users
RESEND_API_KEY=re_NpMHqGuU_NuKJqwEpKRATj378NU8hTYUG
FROM_EMAIL=noreply@ticketcolombia.com
DATABASE_URL=postgresql://usuario:password@host:5432/database
```

### 2.5 Crear Frontend Service
1. En Render Dashboard → "New +" → "Static Site"
2. Conecta tu repositorio GitHub
3. Configuración:
   - **Name**: `ticketcolombia-frontend`
   - **Build Command**: `cd frontend_web && flutter build web --release`
   - **Publish Directory**: `frontend_web/build/web`
   - **Plan**: Free

### 2.6 Variables de Entorno del Frontend
```
API_BASE_URL=https://ticketcolombia-backend.onrender.com
```

## **Paso 3: Configurar Flutter para Web**

### 3.1 Actualizar pubspec.yaml
```yaml
name: ticketcolombia_web
description: Ticket Colombia Web App

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  # ... resto de dependencias
```

### 3.2 Crear archivo de configuración para producción
Crear `frontend_web/lib/config/production.dart`:
```dart
class ProductionConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://ticketcolombia-backend.onrender.com',
  );
}
```

## **Paso 4: Deploy Automático**

### 4.1 Configurar Auto-Deploy
1. En cada servicio (backend y frontend)
2. Ve a "Settings" → "Build & Deploy"
3. Activa "Auto-Deploy" desde la rama `main`

### 4.2 URLs de Acceso
- **Backend API**: `https://ticketcolombia-backend.onrender.com`
- **Frontend Web**: `https://ticketcolombia-frontend.onrender.com`

## **Paso 5: Configurar Dominio Personalizado (Opcional)**

### 5.1 Comprar Dominio
- GoDaddy, Namecheap, etc.
- Ejemplo: `ticketcolombia.com`

### 5.2 Configurar DNS
```
A Record: @ → IP de Render
CNAME: www → ticketcolombia-frontend.onrender.com
CNAME: api → ticketcolombia-backend.onrender.com
```

## **Paso 6: Monitoreo y Logs**

### 6.1 Ver Logs
- Render Dashboard → Tu Servicio → "Logs"
- Monitorea errores y rendimiento

### 6.2 Configurar Alertas
- Render Dashboard → "Alerts"
- Configurar notificaciones por email

## **Paso 7: Optimizaciones**

### 7.1 Backend
- Configurar health checks
- Optimizar queries de base de datos
- Configurar cache

### 7.2 Frontend
- Optimizar imágenes
- Configurar CDN
- Minificar assets

## **Comandos Útiles**

### Verificar Deploy
```bash
# Verificar backend
curl https://ticketcolombia-backend.onrender.com/health

# Verificar frontend
curl https://ticketcolombia-frontend.onrender.com
```

### Logs en Tiempo Real
```bash
# Render CLI (opcional)
npm install -g @render/cli
render logs --service ticketcolombia-backend
```

## **Troubleshooting**

### Error: Build Failed
1. Verificar logs en Render Dashboard
2. Revisar variables de entorno
3. Verificar dependencias en build.gradle.kts

### Error: Database Connection
1. Verificar DATABASE_URL
2. Verificar que la base de datos esté activa
3. Revisar configuración de red

### Error: Frontend No Loads
1. Verificar API_BASE_URL
2. Revisar CORS en backend
3. Verificar build de Flutter

## **Costos Estimados**

- **Free Tier**: $0/mes
  - Backend: 750 horas/mes
  - Frontend: Ilimitado
  - Database: 1GB storage

- **Paid Plans**: Desde $7/mes
  - Para mayor rendimiento
  - Más horas de backend
  - Soporte prioritario

## **Próximos Pasos**

1. ✅ Configurar dominio personalizado
2. ✅ Implementar SSL automático
3. ✅ Configurar backup de base de datos
4. ✅ Implementar CI/CD avanzado
5. ✅ Configurar monitoreo con Sentry
6. ✅ Optimizar rendimiento
