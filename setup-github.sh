#!/bin/bash

echo "🚀 SETUP GITHUB - TICKET COLOMBIA"
echo "=================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "backend/build.gradle.kts" ]; then
    echo "❌ Error: No se encuentra el proyecto backend"
    echo "   Ejecuta este script desde la raíz del proyecto"
    exit 1
fi

# Solicitar usuario de GitHub
echo ""
echo "📝 Ingresa tu usuario de GitHub:"
read -p "Usuario: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ Error: Debes ingresar un usuario de GitHub"
    exit 1
fi

# URL del repositorio
REPO_URL="https://github.com/$GITHUB_USER/ticket-colombia.git"

echo ""
echo "🔧 Configurando Git..."

# Inicializar Git si no existe
if [ ! -d ".git" ]; then
    echo "📦 Inicializando repositorio Git..."
    git init
    git branch -M main
fi

# Verificar si ya existe un remote
if git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  Ya existe un repositorio remoto configurado"
    echo "   Remote actual: $(git remote get-url origin)"
    echo ""
    read -p "¿Deseas cambiarlo? (y/n): " CHANGE_REMOTE
    if [ "$CHANGE_REMOTE" = "y" ] || [ "$CHANGE_REMOTE" = "Y" ]; then
        git remote set-url origin $REPO_URL
        echo "✅ Remote actualizado a: $REPO_URL"
    fi
else
    echo "🔗 Configurando remote origin..."
    git remote add origin $REPO_URL
    echo "✅ Remote configurado: $REPO_URL"
fi

# Agregar todos los archivos
echo ""
echo "📁 Agregando archivos al repositorio..."
git add .

# Commit inicial
echo ""
echo "💾 Creando commit inicial..."
git commit -m "Initial commit - Ticket Colombia MVP

- Backend: Kotlin + Ktor
- Frontend Web: Flutter Web  
- Frontend Mobile: Flutter Mobile
- Database: PostgreSQL
- Authentication: JWT
- Email: Resend API
- QR Codes: ZXing
- PDF: PDFBox

Ready for production deployment on Render.com"

# Push al repositorio
echo ""
echo "📤 Subiendo a GitHub..."
git push -u origin main

echo ""
echo "✅ ¡Proyecto subido a GitHub exitosamente!"
echo ""
echo "🔗 Repositorio: https://github.com/$GITHUB_USER/ticket-colombia"
echo ""
echo "🚀 PRÓXIMOS PASOS PARA DEPLOY:"
echo "1. Ve a https://render.com"
echo "2. Conecta tu repositorio GitHub"
echo "3. Crea una base de datos PostgreSQL"
echo "4. Crea el servicio backend"
echo "5. Crea el servicio frontend"
echo ""
echo "📋 Variables de entorno necesarias:"
echo "   JWT_SECRET=tu-clave-secreta"
echo "   RESEND_API_KEY=re_NpMHqGuU_NuKJqwEpKRATj378NU8hTYUG"
echo "   DATABASE_URL=postgresql://..."
echo ""
echo "🎉 ¡Setup completado!"
