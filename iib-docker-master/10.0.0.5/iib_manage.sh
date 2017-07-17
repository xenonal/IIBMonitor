#!/bin/bash


set -e

NODE_NAME=${NODENAME-IIBV10NODE}

MQstop()
{
	endmqm $MQ_QMGR_NAME
}

MQconfig()
{
	: ${MQ_QMGR_NAME?"ERROR: You need to set the MQ_QMGR_NAME environment variable"}
	source /opt/mqm/bin/setmqenv -s
	echo "----------------------------------------"
	dspmqver
	echo "----------------------------------------"
	mqconfig || (echo -e "\nERROR: mqconfig returned a non-zero return code" 1>&2 ; exit 1)
	echo "----------------------------------------"

	QMGR_EXISTS=`dspmq | grep ${MQ_QMGR_NAME} > /dev/null ; echo $?`
	if [ ${QMGR_EXISTS} -ne 0 ]; then
		echo "Checking filesystem..."
		amqmfsck /var/mqm
		echo "----------------------------------------"
		crtmqm -q ${MQ_QMGR_NAME} || true
		strmqm -e CMDLEVEL=${MQ_QMGR_CMDLEVEL} || true
		echo "----------------------------------------"
	fi
	strmqm ${MQ_QMGR_NAME}
	if [ ${QMGR_EXISTS} -ne 0 ]; then
		echo "----------------------------------------"
		if [ -f /etc/mqm/listener.mqsc ]; then
			runmqsc ${MQ_QMGR_NAME} < /etc/mqm/listener.mqsc
		fi
		if [ -f /etc/mqm/config.mqsc ]; then
			runmqsc ${MQ_QMGR_NAME} < /etc/mqm/config.mqsc
		fi
	fi
	echo "----------------------------------------"
}

MQstate()
{
	dspmq -n -m ${MQ_QMGR_NAME} | awk -F '[()]' '{ print $4 }'
}

MQmonitor()
{
	# Loop until "dspmq" says the queue manager is running
	until [ "`MQstate`" == "RUNNING" ]; do
		sleep 1
	done
	dspmq

	# Loop until "dspmq" says the queue manager is not running any more
	until [ "`MQstate`" != "RUNNING" ]; do
		sleep 5
	done

	# Wait until queue manager has ended before exiting
	while true; do
		MQstate=`MQstate`
		case "$MQstate" in
			ENDED*) break;;
			*) ;;
		esac
		sleep 1
	done
	dspmq
}

stop()
{
	echo "----------------------------------------"
	echo "Stopping node $NODE_NAME..."
	mqsistop $NODE_NAME
}

start()
{
	echo "----------------------------------------"
  /opt/ibm/iib-10.0.0.4/iib version
	echo "----------------------------------------"

  NODE_EXISTS=`mqsilist | grep $NODE_NAME > /dev/null ; echo $?`


	if [ ${NODE_EXISTS} -ne 0 ]; then
    echo "----------------------------------------"
    echo "Node $NODE_NAME does not exist..."
    echo "Creating node $NODE_NAME"
		mqsicreatebroker $NODE_NAME -q ${MQ_QMGR_NAME}
    echo "----------------------------------------"
	fi
	echo "----------------------------------------"
	echo "Starting syslog"
     /usr/sbin/rsyslogd
	echo "Starting node $NODE_NAME"
	mqsistart $NODE_NAME
	echo "----------------------------------------"
}

monitor()
{
	echo "----------------------------------------"
	echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
  # Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while true; do
		sleep 1
	done
}
mq-license-check.sh
# If /var/mqm is empty (because it's mounted from a new host volume), then populate it
if [ ! "$(ls -A /var/mqm)" ]; then
	/opt/mqm/bin/amqicdir -i -f
fi
MQconfig
trap stop SIGTERM SIGINT



iib-license-check.sh
start
trap stop SIGTERM SIGINT
monitor
