#!/sbin/runscript
# Copyright 1999-2011 Pavel Stratil, senbonzakura.eu
# Some functions were taken from debian init script. Licensed under GPL-2
# Distributed under the terms of the GNU General Public License v2
# $Id$

#########################
### Construct vars ######
#########################


SUFFIX=".${SVCNAME#*.}"
[ "${SUFFIX}" == ".drizzled" ] && SUFFIX=''

BASE_CNF="/etc/drizzle/drizzled"
BASE_PID="/var/run/drizzle/drizzled"
BASE_LOG="/var/log/drizzle/drizzled"
BASE_DIR="/var/lib/drizzle/drizzled"

PIDFILE="${BASE_PID}${SUFFIX}.pid"
CNFFILE="${BASE_CNF}${SUFFIX}.cnf"
LOGFILE="${BASE_LOG}${SUFFIX}.log"
DATADIR="${BASE_DIR}${SUFFIX}"
DRIZZLE="/usr/bin/drizzle"
DRIZZLE_USER="drizzle"
DRIZZLE_DAEMON="/usr/sbin/drizzled"
DRIZZLE_EXTRA=""

#########################
### Helper functions ####
#########################


#
# drizzle_status() checks if there is a server running and if it is accessible.
# "check_alive" insists on a pingable server, "check_dead" also fails
# if there is a lost drizzled in the process list
# Usage: boolean drizzle_status [check_alive|check_dead] [warn|nowarn]
#
drizzle_status() {
	ping_output=`$DRIZZLE --ping 2>&1`; ping_alive=$(( ! $? ))
	ps_alive=0
	if [ -f "$PIDFILE" ] && ps `cat $PIDFILE` >/dev/null 2>&1; then ps_alive=1; fi

	if [ "$1" = "check_alive"  -a  $ping_alive = 1 ] ||
	   [ "$1" = "check_dead"   -a  $ping_alive = 0  -a  $ps_alive = 0 ]; then
	   return 0 # EXIT_SUCCESS
	else
	if [ "$2" = "warn" ]; then
		echo -e "$ps_alive processes alive and '$DRIZZLE --ping' resulted in\n$ping_output\n"
	fi
	return 1 # EXIT_FAILURE
	fi
}

#########################
### Main ################
#########################

checkconfig() {
	# TODO: --print-defaults no longer a valid option. Needs to be rewritten.
	#CNFDATADIR=`drizzle_get_param datadir`
		#if [ -z "${CNFDATADIR}" ] ; then
	#   ewarn "Datadir not set in ${CNFFILE}."
	#   ewarn "Trying to use ${DATADIR}"
	#else
	   DATADIR="${CNFDATADIR}"
	#fi

	if [[ ! -d "${DATADIR}" ]] ; then
		eerror "Drizzle datadir is empty or invalid."
		eerror "Please check your configuration ${CNFFILE} and DRIZZLE_EXTRA"
		return 1
	fi

	if [ ! -f "${CNFFILE}" ]; then
		eerror "The configuration file $CNFFILE was not found!"
	fi
}

depend() {
	use localmount
	use gearmand
	use memcached

	# TODO use drizzle_get_param() to decide if gearmand and memcached
	#      are needed. Then the useflag based sed-ing of this script
	#      can be removed from the ebuild.
}


stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --pidfile ${PIDFILE} --stop \
		--exec ${DRIZZLE_DAEMON}
	eend $?
	drizzle_status check_dead warn
}

start() {
	#checkconfig
	ebegin "Starting ${SVCNAME}"
	# Test if ${BASE_PID}, ${BASE_LOG} and ${LOG_FILE} exist, create if not.
	[ ! -e ${BASE_PID} ] && mkdir -p ${BASE_PID} && chown ${DRIZZLE_USER}:nogroup ${BASE_PID}
	[ ! -e ${BASE_LOG} ] && mkdir -p ${BASE_LOG} && chown ${DRIZZLE_USER}:nogroup ${BASE_LOG}
	[ ! -e ${LOGFILE} ]  && touch ${LOGFILE} && chown ${DRIZZLE_USER}:nogroup ${LOGFILE}
	start-stop-daemon --background --pidfile ${PIDFILE} --stderr ${LOGFILE} \
		--user ${DRIZZLE_USER} --start --exec ${DRIZZLE_DAEMON} -- \
		--datadir=${DATADIR} --pid-file=${PIDFILE} --user=${DRIZZLE_USER} \
		${DRIZZLE_EXTRA}
	eend $?

		# TODO in order to have replication always working we should add the
		#      --server-id=# option. AFAIK only integers are allowed, though
		#      ${HOSTNAME}${SVCNAME}${SUFFIX} whould be much easier to handle.

	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14; do
		sleep 1
		if drizzle_status check_alive nowarn ; then break ; fi
	done
	if drizzle_status check_alive warn ; then
		einfo "${SVCNAME} is alive!"
	else
		eerror "${SVCNAME} died!"
	fi
}

status() {
	if drizzle_status check_alive nowarn; then
		einfo "status: started"
	else
		einfo "status: stopped"
	fi
}
