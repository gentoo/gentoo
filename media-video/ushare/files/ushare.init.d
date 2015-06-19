#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ushare/files/ushare.init.d,v 1.4 2012/09/16 14:29:57 hwoarang Exp $

depend() {
	use net
}

start() {
	ebegin "Starting uShare"
	
	# Sanity check to avoid ushare failling on booting with no
	# shared dirs
	if [[ -z "${USHARE_DIRS}" ]] ; then
		eerror "Please set shared dirs in /etc/conf.d/ushare"
		return 1
	fi

	if [[ -z "${USHARE_PORT}" ]] ; then
		einfo "${USHARE_NAME} runs on a dynamic port"
		local ushare_port=
	else
		local ushare_port="--port ${USHARE_PORT}"
		einfo "${USHARE_NAME} using port ${USHARE_PORT}"
	fi

	if [[ "${USHARE_TELNET}" == "yes" ]] ; then
                local ushare_telnet=
        else
                local ushare_telnet="--no-telnet"
        fi

	if [[ -z "${ushare_telnet}" ]] ; then
		if [[ -z "${USHARE_TELNET_PORT}" ]] ; then
                	local ushare_telnet_port=
			einfo "${USHARE_NAME} runs telnet on the default port"
		else
			local ushare_telnet_port="--telnet-port ${USHARE_TELNET_PORT}"
			einfo "${USHARE_NAME} runs telnet on port ${USHARE_TELNET_PORT}"
		fi
        else
                local ushare_telnet_port=
        fi

	if [[ "${USHARE_WEB}" == "yes" ]] ; then
                local ushare_web=
        else
                local ushare_web="--no-web"
        fi

	if [[ "${USHARE_XBOX}" == "yes" ]] ; then
		local ushare_xbox="--xbox"
	else
		local ushare_xbox=
	fi

	if [[ "${USHARE_DLNA}" == "yes" ]] ; then
		local ushare_dlna="--dlna"
	else
		local ushare_dlna=
	fi

	start-stop-daemon --start --quiet -u ${USHARE_USER:-root} \
	--exec /usr/bin/ushare -- -D -i ${USHARE_IFACE}           \
	-n ${USHARE_NAME} ${USHARE_OPTS} ${USHARE_DIRS}           \
	${ushare_port}                                            \
	${ushare_telnet} ${ushare_telnet_port}                    \
	${ushare_web}                                             \
	${ushare_xbox}                                            \
	${ushare_dlna}
	eend $?
}

stop() {
	ebegin "Stopping uShare"
	start-stop-daemon --stop --quiet --exec /usr/bin/ushare
	eend $?
}
