FROM openjdk:8-jdk-alpine
EXPOSE 8090
ADD /target/demo*.jar demo.jar
ENTRYPOINT ["java", "-jar", "demo.jar"]
ss
s
