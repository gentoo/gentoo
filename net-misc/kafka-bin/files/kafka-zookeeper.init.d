#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="Zookeeper for Kafka distributed messaging system"

logfile="/var/log/kafka-zookeeper.log"

command="/opt/kafka/bin/zookeeper-server-start.sh"
command_args="/etc/kafka/zookeeper.properties"
start_stop_daemon_args="--chdir /opt/kafka --stdout $logfile --stderr $logfile"

command_background=yes
pidfile=/run/kafka-zookeeper.pid

depend() {
	need net
	after bootmisc
}
