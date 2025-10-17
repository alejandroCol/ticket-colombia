#!/bin/bash

# Script de build para Render.com
echo "🚀 Iniciando build para Render..."

# Instalar dependencias si es necesario
echo "📦 Verificando dependencias..."

# Build del proyecto
echo "🔨 Ejecutando build..."
./gradlew build

echo "✅ Build completado exitosamente"
