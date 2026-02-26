# Multi-stage build for AssetManager Worker Service
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
RUN mvn dependency:go-offline -B -pl worker -am

# Copy worker source code
COPY worker/src ./worker/src

# Build the worker module
RUN mvn clean package -DskipTests -B -pl worker -am

# Stage 2: Create the runtime image
FROM eclipse-temurin:21-jre-jammy

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/worker/target/assets-manager-worker-*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set JVM options for containerized environment
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Run the worker application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
