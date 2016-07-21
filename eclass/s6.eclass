# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: s6.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @BLURB: helper functions to install s6 services
# @DESCRIPTION:
# This eclass provides helpers to install s6 services.
# @EXAMPLE:
#
# @CODE
# inherit s6
#
# src_install() {
#	...
#	s6_install_service myservice "${FILESDIR}"/run-s6 "${FILESDIR}"/finish-s6
#	...
#	If you want a service to be logged, install the log service as
#	shown here.
#	s6_install_service myservice/log "${FILESDIR}"/log-run-s6 \
#		"${FILESDIR}"/log-finish-s6
#	...
# }
# @CODE

case ${EAPI:-0} in
	5|6) ;;
	*) die "${ECLASS}.eclass: API in EAPI ${EAPI} not yet established" ;;
esac

# @FUNCTION: _s6_get_servicedir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed servicedir.
_s6_get_servicedir() {
	echo /var/svc.d
}

# @FUNCTION: s6_get_servicedir
# @DESCRIPTION:
# Output the path for the s6 service directory (not including ${D}).
s6_get_servicedir() {
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_s6_get_servicedir)"
}

# @FUNCTION: s6_install_service
# @USAGE: servicename run finish
# @DESCRIPTION:
# Install an s6 service.
# servicename is the name of the service.
# run is the run script for the service.
# finish is the optional finish script for the service.
s6_install_service() {
	debug-print-function ${FUNCNAME} "${@}"

	local name="$1"
	local run="$2"
	local finish="$3"

	[[ $name ]] ||
		die "${ECLASS}.eclass: you must specify the s6 service name"
	[[ $run ]] ||
		die "${ECLASS}.eclass: you must specify the s6 service run script"

	(
	local servicepath="$(_s6_get_servicedir)/$name"
	exeinto "$servicepath"
	newexe "$run" run
	[[ $finish ]] && newexe "$finish" finish
	)
}

# @FUNCTION: s6_service_down
# @USAGE: servicename
# @DESCRIPTION:
# Install the "down" flag so this service will not be started by
# default.
# servicename is the name of the service.
s6_service_down() {
	debug-print-function ${FUNCNAME} "${@}"

	local name="$1"

	[[ $name ]] ||
		die "${ECLASS}.eclass: you must specify the s6 service name"

	(
	touch "$T"/down || die
	local servicepath="$(_s6_get_servicedir)/$name"
	insinto "$servicepath"
	doins "$T"/down
	)
}

# @FUNCTION: s6_service_nosetsid
# @USAGE: servicename
# @DESCRIPTION:
# Install the "nosetsid" flag so this service will not be made a session
# leader.
# servicename is the name of the service.
s6_service_nosetsid() {
	debug-print-function ${FUNCNAME} "${@}"

	local name="$1"

	[[ $name ]] ||
		die "${ECLASS}.eclass: you must specify the s6 service name"

	(
	touch "$T"/nosetsid || die
	local servicepath="$(_s6_get_servicedir)/$name"
	insinto "$servicepath"
	doins "$T"/nosetsid
	)
}
