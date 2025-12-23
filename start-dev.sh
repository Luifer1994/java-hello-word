#!/bin/bash

echo "🚀 Iniciando Spring Boot con HOT RELOAD..."

# Compilación inicial completa
echo "📦 Compilación inicial..."
./mvnw clean compile -q

# Iniciar spring-boot en background con fork=false para mejor hot reload
./mvnw spring-boot:run -Dspring-boot.run.fork=false &
SPRING_PID=$!

echo "✅ Spring Boot iniciado (PID: $SPRING_PID)"
echo "👀 Monitoreando cambios en src/main/java..."
echo ""

# Variables para control
LAST_CHECK=$(date +%s)

while true; do
    # Buscar archivos Java modificados recientemente
    CURRENT=$(date +%s)
    
    # Revisar cada 2 segundos
    if [ $((CURRENT - LAST_CHECK)) -ge 2 ]; then
        # Buscar archivos .java modificados en los últimos 3 segundos
        CHANGED_FILES=$(find src/main/java -name "*.java" -newermt "-3 seconds" 2>/dev/null)
        
        if [ ! -z "$CHANGED_FILES" ]; then
            echo "🔄 Cambios detectados:"
            echo "$CHANGED_FILES" | while read file; do
                echo "   - $file"
            done
            echo "📦 Recompilando..."
            
            # Compilar solo lo necesario (incremental)
            ./mvnw compile -q -Dmaven.compiler.useIncrementalCompilation=true
            
            if [ $? -eq 0 ]; then
                echo "✨ Compilación exitosa! DevTools recargará automáticamente..."
                echo ""
            else
                echo "❌ Error en compilación"
            fi
        fi
        
        LAST_CHECK=$CURRENT
    fi
    
    # Verificar si Spring Boot sigue corriendo
    if ! kill -0 $SPRING_PID 2>/dev/null; then
        echo "⚠️  Spring Boot se detuvo"
        exit 1
    fi
    
    sleep 1
done
