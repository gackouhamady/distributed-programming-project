FROM openjdk:21-jdk-slim
VOLUME /tmp
EXPOSE 8080
ADD ./build/libs/user-service-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]