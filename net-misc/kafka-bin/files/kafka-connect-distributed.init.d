#!/sbin/openrc-run
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

description="Kafka Connect of Kafka distributed messaging system"

logfile="/var/log/kafka/connect-distributed.log"

command="/opt/kafka/bin/connect-distributed.sh"
command_args="/etc/kafka/connect-distributed.properties"
command_background=yes
command_user="kafka:kafka"

pidfile=/run/kafka-connect-distributed.pid

start_stop_daemon_args="--stdout $logfile --stderr $logfile
--env CLASSPATH=\"${CLASSPATH}\"
--env KAFKA_LOG4J_OPTS=\"${KAFKA_LOG4J_OPTS}\"
--env KAFKA_OPTS=\"${KAFKA_OPTS}\"
--env KAFKA_JMX_OPTS=\"${KAFKA_JMX_OPTS}\"
--env JMX_PORT=\"${JMX_PORT}\"
--env KAFKA_HEAP_OPTS=\"${KAFKA_HEAP_OPTS}\"
--env KAFKA_JVM_PERFORMANCE_OPTS=\"${KAFKA_JVM_PERFORMANCE_OPTS}\"
"

depend() {
       after kafka
}