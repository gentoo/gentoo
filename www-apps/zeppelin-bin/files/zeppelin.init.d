#!/sbin/openrc-run
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

description="Web-based interactive data analytics notebook launcher"
command="/opt/zeppelin/bin/zeppelin-daemon.sh"
logfile="/var/log/zeppelin/zeppelin-gentoo.log"

start() {
    ebegin "Starting Apache Zeppelin ..."
    bash $command start >> $logfile
    eend $?
}

stop() {
    ebegin "Stopping Apache Zeppelin ..."
    bash $command stop >> $logfile
    eend $?
}
