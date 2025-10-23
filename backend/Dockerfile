# Etapa 1: Build - Compilar la aplicación
FROM gradle:7.6-jdk17 AS build

WORKDIR /app

# Copiar archivos de configuración de Gradle desde la carpeta backend
COPY backend/build.gradle.kts ./build.gradle.kts
COPY backend/settings.gradle.kts ./settings.gradle.kts
COPY backend/gradle.properties ./gradle.properties

# Copiar gradle wrapper
COPY backend/gradle ./gradle
COPY backend/gradlew ./gradlew

# Dar permisos de ejecución al gradlew
RUN chmod +x gradlew

# Descargar dependencias (esto ayuda con el cache)
RUN ./gradlew dependencies --no-daemon || true

# Copiar código fuente
COPY backend/src ./src

# Compilar la aplicación y crear el JAR ejecutable
RUN ./gradlew clean shadowJar --no-daemon --stacktrace

# Verificar que el JAR se creó
RUN ls -la /app/build/libs/ || echo "ERROR: No se encontró el directorio build/libs"

# Etapa 2: Runtime - Imagen final más pequeña
FROM openjdk:17-slim

WORKDIR /app

# Copiar el JAR compilado desde la etapa de build
COPY --from=build /app/build/libs/*-all.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Variables de entorno por defecto (se sobreescribirán en Render)
ENV JWT_SECRET=default-secret
ENV RESEND_API_KEY=default-key
ENV FROM_EMAIL=noreply@example.com
ENV DATABASE_URL=jdbc:postgresql://localhost:5432/ticketcolombia

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
