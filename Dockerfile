FROM openjdk:11

WORKDIR /app

COPY target/java-app-1.0.jar app.jar

EXPOSE 8080

CMD ["java","-jar","app.jar"]
