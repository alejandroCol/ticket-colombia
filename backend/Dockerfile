# Etapa 1: Build - Compilar la aplicación
FROM gradle:7.6-jdk17 AS build

WORKDIR /app

# Copiar archivos de configuración de Gradle
COPY build.gradle.kts settings.gradle.kts ./
COPY gradle gradle
COPY gradlew ./

# Dar permisos de ejecución al gradlew
RUN chmod +x gradlew

# Descargar dependencias (cache layer)
RUN ./gradlew dependencies --no-daemon || true

# Copiar código fuente
COPY src src

# Compilar la aplicación y crear el JAR ejecutable
RUN ./gradlew shadowJar --no-daemon --stacktrace

# Etapa 2: Runtime - Imagen final más pequeña
FROM openjdk:17-slim

WORKDIR /app

# Copiar el JAR compilado desde la etapa de build
COPY --from=build /app/build/libs/backend-1.0.0-all.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Variables de entorno por defecto (se sobreescribirán en Render)
ENV JWT_SECRET=default-secret
ENV RESEND_API_KEY=default-key
ENV FROM_EMAIL=noreply@example.com
ENV DATABASE_URL=jdbc:postgresql://localhost:5432/ticketcolombia

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
