# Ticket Colombia - Guía de Despliegue a Producción

## 📋 Prerrequisitos

### 1. Software Requerido
- **Docker** (versión 20.10+)
- **Docker Compose** (versión 2.0+)
- **Git** (para clonar el repositorio)

### 2. Servicios Externos
- **Resend API Key** (para envío de emails)
- **Dominio** (opcional, para producción)

## 🚀 Despliegue Local con Docker

### Paso 1: Clonar el Repositorio
```bash
git clone <tu-repositorio>
cd Ticket\ Colombia
```

### Paso 2: Configurar Variables de Entorno
```bash
# Copiar el archivo de configuración
cp production.env .env

# Editar las variables según tu configuración
nano .env
```

**Variables importantes a configurar:**
- `JWT_SECRET`: Cambiar por una clave secreta segura
- `RESEND_API_KEY`: Tu clave de API de Resend
- `DATABASE_PASSWORD`: Contraseña segura para PostgreSQL

### Paso 3: Ejecutar con Docker Compose
```bash
# Construir y ejecutar todos los servicios
docker-compose up --build

# O ejecutar en segundo plano
docker-compose up -d --build
```

### Paso 4: Verificar el Despliegue
- **Frontend Web**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **API Health Check**: http://localhost:8080/health

## 🌐 Despliegue en Producción

### Opción 1: VPS/Cloud Server

#### 1. Preparar el Servidor
```bash
# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### 2. Configurar el Dominio
```bash
# Editar nginx.conf para usar tu dominio
server_name tu-dominio.com www.tu-dominio.com;
```

#### 3. Configurar SSL (Opcional)
```bash
# Instalar Certbot para SSL
sudo apt install certbot python3-certbot-nginx

# Obtener certificado SSL
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com
```

### Opción 2: Plataformas Cloud

#### Heroku
1. Crear aplicación en Heroku
2. Conectar con GitHub
3. Configurar variables de entorno
4. Desplegar automáticamente

#### DigitalOcean App Platform
1. Conectar repositorio
2. Configurar servicios (Backend, Frontend, Database)
3. Configurar variables de entorno
4. Desplegar

#### AWS/GCP/Azure
1. Usar servicios de contenedores (ECS, Cloud Run, Container Instances)
2. Configurar load balancers
3. Configurar bases de datos gestionadas
4. Configurar CDN para assets estáticos

## 📱 Configuración para Aplicación Móvil

### Endpoints Disponibles para Mobile

#### Autenticación
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/login` - Login de usuario
- `GET /api/auth/me` - Información del usuario

#### Eventos
- `GET /api/events` - Listar eventos
- `GET /api/events/{id}` - Obtener evento específico

#### Tickets
- `POST /api/tickets/validate` - Validar ticket (QR Scanner)
- `GET /api/tickets?eventId={id}` - Listar tickets de un evento

### Configuración de CORS
El backend ya está configurado para aceptar requests desde cualquier origen en desarrollo. Para producción, actualizar:

```kotlin
// En Application.kt
install(CORS) {
    anyHost() // Cambiar por hosts específicos en producción
    allowHeader(HttpHeaders.ContentType)
    allowHeader(HttpHeaders.Authorization)
    allowMethod(HttpMethod.Options)
    allowMethod(HttpMethod.Post)
    allowMethod(HttpMethod.Get)
    allowMethod(HttpMethod.Put)
    allowMethod(HttpMethod.Delete)
}
```

## 🔧 Configuración de Base de Datos

### Migración a PostgreSQL (Futuro)
Actualmente la aplicación usa almacenamiento JSON. Para migrar a PostgreSQL:

1. **Configurar PostgreSQL**:
```bash
# Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib

# Crear base de datos
sudo -u postgres createdb ticketcolombia
sudo -u postgres createuser ticketcolombia
sudo -u postgres psql -c "ALTER USER ticketcolombia PASSWORD 'tu-password';"
```

2. **Actualizar configuración**:
- Cambiar `DataStorage` por `DatabaseConfig`
- Implementar modelos Exposed
- Actualizar servicios para usar PostgreSQL

## 📊 Monitoreo y Logs

### Verificar Logs
```bash
# Logs de todos los servicios
docker-compose logs

# Logs de un servicio específico
docker-compose logs backend
docker-compose logs frontend-web
docker-compose logs postgres
```

### Health Checks
- **Backend**: `GET /health`
- **Frontend**: `GET /`
- **Database**: Verificar conexión en logs

## 🔒 Seguridad en Producción

### 1. Variables de Entorno
- Cambiar todas las contraseñas por defecto
- Usar JWT secrets seguros
- Configurar CORS para dominios específicos

### 2. Firewall
```bash
# Configurar UFW
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

### 3. SSL/TLS
- Usar certificados SSL válidos
- Configurar HTTPS redirect
- Usar headers de seguridad

## 🚀 Comandos Útiles

### Desarrollo
```bash
# Ejecutar solo el backend
cd backend && ./gradlew run

# Ejecutar solo el frontend
cd frontend_web && flutter run -d chrome --web-port=3000
```

### Producción
```bash
# Reiniciar servicios
docker-compose restart

# Actualizar aplicación
docker-compose pull
docker-compose up -d

# Limpiar recursos no utilizados
docker system prune -a
```

### Backup
```bash
# Backup de base de datos
docker-compose exec postgres pg_dump -U ticketcolombia ticketcolombia > backup.sql

# Restaurar backup
docker-compose exec -T postgres psql -U ticketcolombia ticketcolombia < backup.sql
```

## 📞 Soporte

Para problemas o dudas:
1. Revisar logs: `docker-compose logs`
2. Verificar configuración de variables de entorno
3. Comprobar conectividad entre servicios
4. Verificar que los puertos estén disponibles

## 🔄 Actualizaciones

Para actualizar la aplicación:
1. Hacer pull de los cambios: `git pull`
2. Reconstruir imágenes: `docker-compose build`
3. Reiniciar servicios: `docker-compose up -d`
4. Verificar que todo funcione correctamente
