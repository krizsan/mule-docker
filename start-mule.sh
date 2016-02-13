#! /bin/sh
# Set the timezone. Base image does not contain the setup-timezone script, so an alternate way is used.
if [ "$SET_CONTAINER_TIMEZONE" = "true" ]; then
    cp /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime && \
	echo "${CONTAINER_TIMEZONE}" >  /etc/timezone && \
	echo "Container timezone set to: $CONTAINER_TIMEZONE"
else
	echo "Container timezone not modified"
fi

# Force immediate synchronisation of the time and start the time-synchronization service.
# In order to be able to use ntpd in the container, it must be run with the SYS_TIME capability.
# In addition you may want to add the SYS_NICE capability, in order for ntpd to be able to modify its priority.
ntpd -s

# Start Mule ESB.
# The Mule startup script will take care of launching Mule using the appropriate user.
exec ${MULE_HOME}/bin/mule
