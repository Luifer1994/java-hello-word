FROM openjdk:25-ea-21-jdk-slim

WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .

# Dar permisos de ejecución al wrapper de Maven
RUN chmod +x mvnw

# Descargar dependencias (esto se cachea)
RUN ./mvnw dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Exponer puerto de la aplicación
EXPOSE 8080

# Copiar script de inicio con hot reload
COPY start-dev.sh .
RUN chmod +x start-dev.sh

# Ejecutar script que monitorea cambios y recompila automáticamente
CMD ["./start-dev.sh"]
