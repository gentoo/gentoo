#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

depend() {
	need net
}

checkconfig() {
	if [ ! -e "${GIMPS_DIR}" ]; then
		einfo "Creating ${GIMPS_DIR}"
		/bin/mkdir "${GIMPS_DIR}"
	fi

	/bin/chown -R ${USER}:${GROUP} ${GIMPS_DIR}

	if [ ! -e "${GIMPS_DIR}/local.txt" ]; then
		eerror "GIMPS has not been configured.  Please configure it manually before"
		eerror "starting this initscript."
		return 1
	fi
}

start() {
	checkconfig || return 1
	ebegin "Starting GIMPS"
	start-stop-daemon --quiet --start -b --exec /opt/gimps/mprime \
			--chdir ${GIMPS_DIR} --user ${USER}:${GROUP} \
			-- -w${GIMPS_DIR} ${GIMPS_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping GIMPS"
	start-stop-daemon --quiet --stop --exec /opt/gimps/mprime
	eend $?
}
