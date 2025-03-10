FROM registry.access.redhat.com/quarkus/mandrel-for-jdk-21-rhel8:23.1 AS builder
USER root
WORKDIR /build/
COPY . /build/
RUN ls -la .
RUN ./mvnw clean package -Pnative

FROM registry.redhat.io/ubi8/ubi-minimal
WORKDIR /deployments/
COPY --from=builder /build/target/*-runner /deployments/application
RUN chmod 110 /deployments/application
CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]