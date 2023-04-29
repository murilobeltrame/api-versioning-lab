FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu AS build
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw package -DskipTests

FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu

EXPOSE 8080

WORKDIR /app
COPY --from=build ./app/target/example-0.0.1-SNAPSHOT.war .

ENTRYPOINT [ "java", "-jar", "example-0.0.1-SNAPSHOT.war"]