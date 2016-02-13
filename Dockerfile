# Mule ESB Community Edition Docker image running on Alpine Linux and Oracle Java 8 (JRE).
# The base image contains glibc, which is required for the Java Service wrapper that is used by Mule ESB.
#
# Build image with: docker build -t ivankrizsan/mule:latest .

FROM anapsix/alpine-java:jre8

MAINTAINER Ivan Krizsan, https://github.com/krizsan

# Mule ESB CE version number.
ENV MULE_VERSION 3.7.0
# Mule home directory in Docker image.
ENV MULE_HOME /opt/mule-standalone
ENV MULE_DOWNLOAD_URL https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz
# User and group that the Mule ESB instance will be run as, in order not to run as root.
# Note that the name of this property must match the property name used in the Mule ESB startup script.
ENV RUN_AS_USER mule
# Set this environment variable to true to set timezone on container start.
ENV SET_CONTAINER_TIMEZONE false
# Default container timezone.
ENV CONTAINER_TIMEZONE Europe/Stockholm

# Install NTPD for time synchronization.
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add tzdata openntpd && \
# Create the /opt directory in which software in the container is installed.
    mkdir -p /opt && \
    cd /opt && \
# Create directory used by NTPD.
    mkdir -p /var/empty && \
# Create the user and group that will be used to run Mule ESB.
    addgroup ${RUN_AS_USER} && adduser -D -G ${RUN_AS_USER} ${RUN_AS_USER} && \
# Install Mule ESB.
    wget ${MULE_DOWNLOAD_URL} && \
    tar xvzf mule-standalone-*.tar.gz && \
    rm mule-standalone-*.tar.gz && \
    mv mule-standalone-* mule-standalone && \
# Set the owner of all Mule-related files to the user which will be used to run Mule.
    chown -R ${RUN_AS_USER}:${RUN_AS_USER} mule-standalone

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Copy the script used to launch Mule ESB when a container is started.
COPY ./start-mule.sh /opt/
# Make the start-script executable.
RUN chmod +x /opt/start-mule.sh

WORKDIR ${MULE_HOME}

# Default when starting the container is to start Mule ESB.
CMD [ "/opt/start-mule.sh" ]

# Default http port
EXPOSE 8081
