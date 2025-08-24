# FROM openjdk:11
# COPY ./target/demo1-0.0.1-SNAPSHOT.jar demo1-0.0.1-SNAPSHOT.jar
# ENTRYPOINT ["java", "-jar", "demo1-0.0.1-SNAPSHOT.jar"]


FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the JAR file from target directory
COPY target/*.jar app.jar

# Expose port (adjust based on your application)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]