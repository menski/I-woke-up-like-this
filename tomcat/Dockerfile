FROM alpine:3.4

EXPOSE 8080

WORKDIR /camunda

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/camunda/bin/catalina.sh", "run"]

RUN apk --no-cache add openjdk8-jre-base openssl tini

ARG NEXUS=https://app.camunda.com/nexus/service/local/artifact/maven/content
ARG REPOSITORY=camunda-bpm
ARG GROUP=org.camunda.bpm.tomcat
ARG ARTIFACT=camunda-bpm-tomcat
ARG VERSION=7.6.0-alpha1

RUN mkdir -p /tmp/camunda && \
    wget "${NEXUS}?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=tar.gz" -O /tmp/camunda/camunda-bpm.tar.gz && \
    tar xzf /tmp/camunda/camunda-bpm.tar.gz -C /tmp/camunda && \
    mv /tmp/camunda/server/apache-tomcat-*/* /camunda/ && \
    rm -rf /tmp/camunda

