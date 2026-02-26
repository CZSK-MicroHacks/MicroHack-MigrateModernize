# Multi-stage build for AssetManager Web Application
# Build context must be the AssetManager root directory
# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-21-jammy AS build

WORKDIR /app

# Copy parent pom
COPY pom.xml ./pom.xml

# Copy module poms for dependency resolution
COPY web/pom.xml ./web/pom.xml
COPY worker/pom.xml ./worker/pom.xml

# Download dependencies (cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B -pl web -am

# Copy web source code
COPY web/src ./web/src

# Build the web module
RUN mvn clean package -DskipTests -B -pl web -am

# Stage 2: Create the runtime image
FROM eclipse-temurin:21-jre-jammy

# Install curl for health checks
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/web/target/assets-manager-web-*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Set JVM options for containerized environment
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
