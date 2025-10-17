#!/bin/bash

echo "🚀 DEPLOY A RENDER.COM - TICKET COLOMBIA"
echo "========================================"

# Verificar que estamos en el directorio correcto
if [ ! -f "backend/build.gradle.kts" ]; then
    echo "❌ Error: No se encuentra el proyecto backend"
    echo "   Ejecuta este script desde la raíz del proyecto"
    exit 1
fi

# Verificar que Git está configurado
if [ ! -d ".git" ]; then
    echo "📦 Inicializando repositorio Git..."
    git init
    git branch -M main
fi

# Verificar cambios pendientes
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 Agregando cambios al repositorio..."
    git add .
    git commit -m "Deploy to Render - $(date)"
fi

# Verificar conexión con GitHub
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  No hay repositorio remoto configurado"
    echo "   Configura tu repositorio GitHub:"
    echo "   git remote add origin https://github.com/TU_USUARIO/ticket-colombia.git"
    echo ""
    echo "   Luego ejecuta:"
    echo "   git push -u origin main"
    exit 1
fi

# Push a GitHub
echo "📤 Subiendo cambios a GitHub..."
git push origin main

echo ""
echo "✅ Código subido a GitHub exitosamente"
echo ""
echo "🔧 PRÓXIMOS PASOS EN RENDER.COM:"
echo "1. Ve a https://render.com"
echo "2. Conecta tu repositorio GitHub"
echo "3. Crea una base de datos PostgreSQL"
echo "4. Crea el servicio backend con:"
echo "   - Build Command: cd backend && ./gradlew build"
echo "   - Start Command: cd backend && ./gradlew run"
echo "5. Crea el servicio frontend con:"
echo "   - Build Command: cd frontend_web && flutter build web --release"
echo "   - Publish Directory: frontend_web/build/web"
echo ""
echo "📋 Variables de entorno necesarias:"
echo "   JWT_SECRET=tu-clave-secreta"
echo "   RESEND_API_KEY=re_NpMHqGuU_NuKJqwEpKRATj378NU8hTYUG"
echo "   DATABASE_URL=postgresql://..."
echo "   API_BASE_URL=https://tu-backend.onrender.com"
echo ""
echo "🎉 ¡Deploy completado!"
