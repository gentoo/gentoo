#!/sbin/openrc-run
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

description="The x11vnc daemon init script"

depend() {
	need net
	need xdm
}

checkconfig() {

	# Set Defaults
	X11VNC_RFBAUTH=${X11VNC_RFBAUTH:-/etc/x11vnc.pass}
	X11VNC_RFBPORT=${X11VNC_RFBPORT:-5900}
	X11VNC_DISPLAY=${X11VNC_DISPLAY:-:0}
	X11VNC_LOG=${X11VNC_LOG:-/var/log/x11vnc}
	
	X11VNC_AUTH="/var/run/x11vnc-${X11VNC_DISPLAY}"	

	if [ -n "${X11VNC_AUTOPORT}" ]; then
		X11VNC_PORT=""
	fi

	if [ ! -f "${X11VNC_RFBAUTH}" -o ! -s "${X11VNC_RFBAUTH}" ]; then
		eerror "VNC Password not set, please set one by running: \`x11vnc -storepasswd ${X11VNC_RFBAUTH}\`"
		return 1
	fi
	checkpath -q -f -m 0600 -o root:root "${X11VNC_RFBAUTH}"

	# Attempt to find X-Auth file
	if ! type xauth > /dev/null 2>&1 ||
			! xauth -f /root/.Xauthority extract - "${X11VNC_DISPLAY}" > "${X11VNC_AUTH}" 2>/dev/null ||
			[ ! -s "${X11VNC_AUTH}" ]; then
		# Let x11vnc guess at auth
		X11VNC_AUTH_OPTS="--env FD_XDM=1 -auth guess"
	else
		# We found the proper auth
		X11VNC_AUTH_OPTS="-auth ${X11VNC_AUTH}"
	fi

	if [ ! -f "${X11VNC_AUTH}" ]; then
		eerror "Specified X-Authority file '${X11VNC_AUTH}' not found!"
		return 1
	fi	
}

start() {
	checkconfig || return 1

	ebegin "Starting ${SVCNAME}"
	start-stop-daemon --start \
		--exec /usr/bin/x11vnc -- \
			${X11VNC_AUTH_OPTS} \
			-rfbauth ${X11VNC_RFBAUTH} \
			${X11VNC_RFBPORT:+-rfbport} ${X11VNC_RFBPORT} \
			${X11VNC_AUTOPORT:+-autoport} ${X11VNC_AUTOPORT} \
			-display ${X11VNC_DISPLAY} \
			-o ${X11VNC_LOG} \
			-bg -forever \
			${X11VNC_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop /usr/bin/x11vnc
	eend $?
}
