#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the Torque 2.5+ License

. /etc/conf.d/torque 
PBS_SERVER_HOME="$(. /etc/env.d/25torque; echo ${PBS_SERVER_HOME})"

depend() {
    need net
    after pbs_server
    before pbs_mom
    after logger
}

checkconfig() {
    for i in "server_name"; do
        if [ ! -e ${PBS_SERVER_HOME}/${i} ]; then
            eerror "Missing config file ${PBS_SERVER_HOME}/${i}"
            return 1
        fi
    done

    if [ -z "$(grep 'queue_type' ${PBS_SERVER_HOME}/server_priv/queues/*)" ]; then
        eerror "No queues have been defined yet."
        return 1
    fi
}

start() {
    checkconfig || return 1
	
    ebegin "Starting Torque pbs_sched"
    local extra_args=""
    if [ -n "${PBS_SCHED_LOG}" ]; then
        extra_args="-L ${PBS_SCHED_LOG}"
    fi

    start-stop-daemon  --start -p ${PBS_SERVER_HOME}/sched_priv/sched.lock \
        --exec /usr/sbin/pbs_sched -- -d ${PBS_SERVER_HOME} ${extra_args}
    eend ${?}		
}

stop() {
    ebegin "Stopping Torque pbs_sched"
    start-stop-daemon --stop -p ${PBS_SERVER_HOME}/sched_priv/sched.lock
    eend ${?}
}
# vim:ts=4
