#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="Kafka distributed messaging system"

logfile="/var/log/kafka/kafka.log"

command="/opt/kafka/bin/kafka-server-start.sh"
command_args="/etc/kafka/server.properties"
start_stop_daemon_args="--user kafka --chdir /opt/kafka --stdout $logfile --stderr $logfile"

command_background=yes
pidfile=/run/kafka.pid

depend() {
       after zookeeper kafka-zookeeper
}
