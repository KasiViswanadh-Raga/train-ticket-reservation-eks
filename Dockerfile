# Build stage: use Maven to compile and package the app
FROM maven:3.8.7-openjdk-17 AS build

WORKDIR /app

# Copy pom and source code
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

# Package into WAR
RUN mvn clean package -DskipTests

# Runtime stage: use Tomcat base image
FROM tomcat:9.0-jdk17

# Remove default ROOT app (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copy your WAR file into Tomcat webapps
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
