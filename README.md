# Mule ESB Community Edition Docker Image
Docker image with Mule ESB on Alpine Linux and Oracle Java 8 (JRE).

In order for the time of the container to be synchronized (using ntpd), it must be run with the SYS_TIME capability.
In addition you may want to add the SYS_NICE capability, in order for ntpd to be able to modify its priority.
Example:
```
docker run --cap-add=SYS_TIME --cap-add=SYS_NICE ivankrizsan/mule:latest
```

## Volumes
/opt/mule-standalone/logs       - Log output directory.<br/>
/opt/mule-standalone/config     - Directory containing configuration for applications, domains etc.<br/>
/opt/mule-standalone/apps       - Deployment directory for Mule applications.<br/>
/opt/mule-standalone/domains    - Deployment directory for Mule domains.<br/>

## Environment
SET_CONTAINER_TIMEZONE - Set to "true" (without quotes) to set the timezone when starting a container. Default is false.<br/>
CONTAINER_TIMEZONE - Timezone to use in container. Default is Europe/Stockholm.<br/>
Example:
```
docker run -e "SET_CONTAINER_TIMEZONE=true" -e "CONTAINER_TIMEZONE=Europe/Stockholm" ivankrizsan/mule:latest
```

## Exposed ports
8081    -   Default HTTP port.

## Note!
Mule ESB on Alpine Linux has not, to my knowledge, received extensive testing.
