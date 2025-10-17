# 🚀 Guía de Deploy en Cloud (Sin Docker)

## **Opción 1: Heroku (Gratis)**

### **Backend en Heroku:**
```bash
# 1. Instalar Heroku CLI
brew install heroku/brew/heroku

# 2. Login en Heroku
heroku login

# 3. Crear app en Heroku
heroku create ticketcolombia-backend

# 4. Configurar variables de entorno
heroku config:set JWT_SECRET=tu-clave-secreta-super-segura
heroku config:set RESEND_API_KEY=tu-resend-api-key
heroku config:set DATABASE_URL=postgresql://usuario:password@host:5432/database

# 5. Deploy
cd backend
git init
git add .
git commit -m "Initial commit"
git push heroku main
```

### **Frontend en Netlify:**
```bash
# 1. Build del frontend
cd frontend_web
flutter build web --release

# 2. Subir carpeta build/web a Netlify
# - Ve a netlify.com
# - Arrastra la carpeta build/web
# - Configura redirects para SPA
```

## **Opción 2: Vercel (Gratis)**

### **Backend:**
```bash
# 1. Instalar Vercel CLI
npm i -g vercel

# 2. En la carpeta backend
vercel

# 3. Configurar variables de entorno en Vercel dashboard
```

### **Frontend:**
```bash
# 1. Build del frontend
cd frontend_web
flutter build web --release

# 2. Deploy a Vercel
vercel --prod
```

## **Opción 3: Railway (Gratis)**

### **Backend:**
```bash
# 1. Instalar Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Deploy
cd backend
railway up
```

## **Opción 4: Render (Gratis)**

### **Backend:**
1. Conecta tu repositorio GitHub a Render
2. Selecciona "Web Service"
3. Configura:
   - Build Command: `cd backend && ./gradlew build`
   - Start Command: `cd backend && ./gradlew run`
   - Environment: Java

### **Frontend:**
1. Selecciona "Static Site"
2. Build Command: `cd frontend_web && flutter build web --release`
3. Publish Directory: `frontend_web/build/web`

## **Opción 5: DigitalOcean App Platform (Gratis)**

1. Conecta tu repositorio
2. Configura servicios:
   - Backend: Java/Kotlin
   - Frontend: Static Site
   - Database: PostgreSQL

## **Configuración de Variables de Entorno:**

Para cualquier servicio cloud, configura estas variables:

```bash
# Backend
JWT_SECRET=tu-clave-secreta-super-segura-2024
JWT_ISSUER=ticketcolombia
JWT_AUDIENCE=ticketcolombia-users
RESEND_API_KEY=tu-resend-api-key
DATABASE_URL=postgresql://usuario:password@host:5432/database

# Frontend
API_BASE_URL=https://tu-backend-url.com
```

## **Base de Datos:**

### **Opción 1: PostgreSQL Gratis**
- **Supabase** (gratis): https://supabase.com
- **Neon** (gratis): https://neon.tech
- **Railway PostgreSQL** (gratis)
- **Render PostgreSQL** (gratis)

### **Configuración de Supabase:**
1. Crea cuenta en supabase.com
2. Crea nuevo proyecto
3. Ve a Settings > Database
4. Copia la connection string
5. Usa como DATABASE_URL

## **Dominio Personalizado:**

1. Compra un dominio (GoDaddy, Namecheap, etc.)
2. Configura DNS:
   - Backend: api.tudominio.com
   - Frontend: tudominio.com
3. Configura SSL automático en el servicio cloud

## **Monitoreo:**

- **Uptime Robot** (gratis): Para monitorear que esté funcionando
- **Sentry** (gratis): Para errores
- **Google Analytics**: Para estadísticas del frontend

## **Pasos Rápidos Recomendados:**

1. **Backend**: Railway o Render
2. **Frontend**: Netlify o Vercel  
3. **Database**: Supabase
4. **Email**: Resend (ya configurado)
5. **Dominio**: Opcional, pero recomendado

## **Comandos de Deploy Rápido:**

```bash
# 1. Backend en Railway
cd backend
railway login
railway up

# 2. Frontend en Netlify
cd frontend_web
flutter build web --release
# Subir build/web a Netlify

# 3. Database en Supabase
# Crear proyecto en supabase.com
# Copiar connection string
# Configurar en Railway/Render
```
