# Mule ESB Community Edition Docker image running on Alpine Linux and Oracle Java 8 (JDK).
# The base image contains glibc, which is required for the Java Service wrapper that is used by Mule ESB.
#
FROM anapsix/alpine-java:8_jdk_unlimited

MAINTAINER Ivan Krizsan, https://github.com/krizsan

# Mule ESB CE version number.
ENV MULE_VERSION=3.8.1
ENV MULE_DOWNLOAD_URL=https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz
# Mule home directory in Docker image.
ENV MULE_HOME=/opt/mule-standalone \
# User and group that the Mule ESB instance will be run as, in order not to run as root.
# Note that the name of this property must match the property name used in the Mule ESB startup script.
    RUN_AS_USER=mule \
# Set this environment variable to true to set timezone on container start.
    SET_CONTAINER_TIMEZONE=true \
# Default container timezone.
    CONTAINER_TIMEZONE=Europe/Stockholm

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
# Needed for SSL support when downloading Mule ESB from HTTPS URL.
    apk --no-cache add ca-certificates && \
    update-ca-certificates && \
    apk --no-cache add openssl && \
# Install Mule ESB.
    wget ${MULE_DOWNLOAD_URL} && \
    tar xvzf mule-standalone-*.tar.gz && \
    rm mule-standalone-*.tar.gz && \
    mv mule-standalone-* mule-standalone

# Copy the script used to launch Mule ESB when a container is started.
COPY ./start-mule.sh /opt/
# Copy configuration files to Mule ESB configuration directory.
COPY ./conf/*.* ${MULE_HOME}/conf/

# Make the start-script executable.
RUN chmod +x /opt/start-mule.sh && \
# Set the owner of all Mule-related files to the user which will be used to run Mule.
    chown -R ${RUN_AS_USER}:${RUN_AS_USER} ${MULE_HOME} && \
# Restrict access to the JMX passwords file, or Mule ESB will fail to startup.
    chmod 600 ${MULE_HOME}/conf/jmx.password

WORKDIR ${MULE_HOME}

# Default when starting the container is to start Mule ESB.
CMD [ "/opt/start-mule.sh" ]

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Default http port
EXPOSE 8081
# JMX port.
EXPOSE 1099

