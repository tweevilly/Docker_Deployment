# Runtime base: Eclipse Temurin OpenJDK 17 (matches <java.version>17</java.version> in pom.xml)
FROM eclipse-temurin:17-jdk-jammy

#LABEL authors="Thuy-Vi"

# Working directory inside the container
WORKDIR /app

# Copy the Spring Boot jar (built by `mvn package`) into the image.
# The file name must match the jar in target/ exactly.
COPY target/D387_sample_code-0.0.2-SNAPSHOT.jar app.jar

# Port the Spring Boot app listens on (documentation only; publish it with -p at run time)
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
