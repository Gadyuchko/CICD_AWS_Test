FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} testapp.jar
ENTRYPOINT ["java","-jar","testapp.jar"]
EXPOSE 8080