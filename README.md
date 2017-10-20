# Mule ESB Community Edition Docker Image
Docker image with Mule ESB on Linux and Java 8.
Mule ESB versions prior to version 4 are built on Alpine Linux and Oracle Java 8.
Version 4 is built on Debian and OpenJDK 8.

## Building
Before building with Maven, the DOCKER_HOST environment variable needs to be set.
Example on Windows:<br/>
```set DOCKER_HOST=http://192.168.99.100:2375```
To build, use docker:build with the appropriate profile. Example:<br/>
```mvn -Pmule-4.0.0-rc docker:build```

## Running
In order for the time of the container to be synchronized (using ntpd), it must be run with the SYS_TIME capability.
In addition you may want to add the SYS_NICE capability, in order for ntpd to be able to modify its priority.

Example:
```
docker run --cap-add=SYS_TIME --cap-add=SYS_NICE ivankrizsan/mule-docker:latest
```

## Volumes
- /opt/mule-standalone/logs       - Log output directory.
- /opt/mule-standalone/config     - Directory containing configuration for applications, domains etc.
- /opt/mule-standalone/apps       - Deployment directory for Mule applications.
- /opt/mule-standalone/domains    - Deployment directory for Mule domains.

## Environment
- SET_CONTAINER_TIMEZONE - Whether to set the timezone of the Docker container when starting it. Default is true.
- CONTAINER_TIMEZONE - Timezone to use in container. Default is Europe/Stockholm.
- MULE_EXTERNAL_IP - External IP address of the Docker container. On Mac and Windows this will be the Docker machine's IP address.
This IP address is used to expose JMX of the Mule ESB instance running in the Docker container.

Example:
```
docker run --cap-add=SYS_TIME --cap-add=SYS_NICE -e "SET_CONTAINER_TIMEZONE=true" -e "CONTAINER_TIMEZONE=Europe/Stockholm" -e "MULE_EXTERNAL_IP=192.168.99.100" -p "1099:1099" ivankrizsan/mule-docker:latest
```

## Exposed ports
- 8081  - Default HTTP port.
- 1099  - JMX port.
- 8899  - Jolokia HTTP service port.

## JXM Monitoring
To monitor a Mule ESB instance running in a Docker container, use the following JMX service URL:<br/>
```
service:jmx:rmi:///jndi/rmi://192.168.99.100:1099/jmxrmi
```
<br/>Note that the IP address may need to be updated and the port number depends on the port mapping configuration when the container was launched.<br/>

## JMX Monitoring with Jolokia
Jolokia is installed in the Mule ESB running in containers created from this Docker image.
Its HTTP API is exposed on the Jolokia HTTP service port as listed above.
To change this port, modify the mule-config.xml file in the jolokia-enabler Mule application.
For more information on Jolokia, please refer to https://jolokia.org/

## Note!
Mule ESB on Alpine Linux has not, to my knowledge, received extensive testing.

## Mule ESB 4
Due to differences in Mule ESB 4, the Docker image containing this version is built using Debian.
In addition does not have Jolokia installed.
