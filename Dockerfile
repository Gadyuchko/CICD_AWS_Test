FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} CICD_AWS_Test-1.0-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","CICD_AWS_Test-1.0-SNAPSHOT.jar"]
EXPOSE 8080