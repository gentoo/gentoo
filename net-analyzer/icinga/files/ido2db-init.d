#!/sbin/openrc-run
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

get_config() {
    if [ -e "${IDO2DBCFG}" ]; then
        sed -n -e 's:^[ \t]*'$1'=\([^#]\+\).*:\1:p' "${IDO2DBCFG}"
    fi
}

command=/usr/sbin/ido2db
command_args="-c ${IDO2DBCFG}"
pidfile="$(get_config lock_file)"

depend() {
	config "${IDO2DBCFG}"

	need net icinga
	use dns logger firewall

	case $(get_config db_servertype) in
	    mysql)
		use mysql ;;
	    pgsql)
		use postgresql ;;
	esac
}

IDO2DBSOCKET="$(get_config socket_name)"


start_pre() {
	if [ -S "${IDO2DBSOCKET}" ] ; then
		ewarn "Strange, the socket file already exist in \"${IDO2DBSOCKET}\""
		ewarn "it will be removed now and re-created by ido2db"
		ewarn "BUT please make your checks."
		rm -f "${IDO2DBSOCKET}"
	fi
}
