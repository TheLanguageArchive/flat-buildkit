# syntax=docker/dockerfile:1.5.1
FROM tomcat:9.0.96-jre21

ARG TARGETARCH
ARG FCREPO_VERSION=6.5.0
ARG FCREPO_FILE=fcrepo-webapp-${FCREPO_VERSION}.war
ARG FCREPO_URL=https://github.com/fcrepo/fcrepo/releases/download/fcrepo-${FCREPO_VERSION}/${FCREPO_FILE}
ARG FCREPO_SHA256=dd0ac889f253dbe9fb09aa3f1fe4444fd57b51af34ebaaf23daec72fbdc5cf55

ARG SYN_VERSION=1.1.1
ARG SYN_FILE=islandora-syn-${SYN_VERSION}-all.jar
ARG SYN_URL=https://github.com/Islandora-CLAW/Syn/releases/download/v${SYN_VERSION}/${SYN_FILE}
ARG SYN_SHA256=24c589d16d579c48361d14c346e0d633a6985642f1c116295ed91eb32b283085

ENV DOWNLOAD_CACHE_DIRECTORY=/opt/downloads

# Platform agnostic does not require arch specific identifier.
RUN --mount=type=bind,source=rootfs/usr/local/bin/download.sh,target=/usr/local/bin/download.sh \
    --mount=type=bind,source=rootfs/usr/local/bin/cleanup.sh,target=/usr/local/bin/cleanup.sh \
    --mount=type=cache,id=fcrepo6-downloads-${TARGETARCH},sharing=locked,target=/opt/downloads \
    apt update \
    && \
    apt install -y unzip wget \
    && \
    download.sh \
    --url ${FCREPO_URL} \
    --sha256 ${FCREPO_SHA256} \
    --dest /usr/local/tomcat/webapps/fcrepo \
    && \
    download.sh \
    --url ${SYN_URL} \
    --sha256 ${SYN_SHA256} \
    --dest /usr/local/tomcat/lib
#&& \
#cleanup.sh

ENV \
    FCREPO_ACTIVEMQ_BROKER=tcp://activemq:61616 \
    FCREPO_ACTIVEMQ_QUEUE=fedora \
    FCREPO_ACTIVEMQ_TOPIC=fedora \
    FCREPO_DB_NAME=fcrepo \
    FCREPO_DB_PASSWORD=password \
    FCREPO_DB_USER=fcrepo \
    FCREPO_DISABLE_SYN=false \
    FCREPO_PERSISTENCE_TYPE=file \
    FCREPO_TOMCAT_ADMIN_ROLES=manager-gui,fedoraAdmin \
    FCREPO_S3_BUCKET= \
    FCREPO_S3_PASSWORD= \
    FCREPO_S3_USER= \
    FCREPO_AWS_REGION=us-east-1 \
    FCREPO_S3_PREFIX=

COPY --link ./rootfs /

#RUN chown -R tomcat:tomcat /opt/tomcat
