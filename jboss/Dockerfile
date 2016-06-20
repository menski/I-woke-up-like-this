FROM alpine:3.4

EXPOSE 8080

WORKDIR /camunda

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/camunda/bin/standalone.sh"]

# jboss settings
ENV PREPEND_JAVA_OPTS="-Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0" \
    LAUNCH_JBOSS_IN_BACKGROUND=TRUE

RUN apk --no-cache add openjdk7-jre-base openssl tini

ARG NEXUS=https://app.camunda.com/nexus/service/local/artifact/maven/content
ARG REPOSITORY=camunda-bpm
ARG GROUP=org.camunda.bpm.jboss
ARG ARTIFACT=camunda-bpm-jboss
ARG VERSION=7.6.0-alpha1

RUN mkdir -p /tmp/camunda && \
    wget "${NEXUS}?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=tar.gz" -O /tmp/camunda/camunda-bpm.tar.gz && \
    tar xzf /tmp/camunda/camunda-bpm.tar.gz -C /tmp/camunda && \
    mv /tmp/camunda/server/jboss-*/* /camunda/ && \
    rm -rf /tmp/camunda
