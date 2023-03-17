# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: webapp.eclass
# @MAINTAINER:
# web-apps@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: functions for installing applications to run under a web server
# @DESCRIPTION:
# The webapp eclass contains functions to handle web applications with
# webapp-config. Part of the implementation of GLEP #11

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_WEBAPP_ECLASS} ]]; then
_WEBAPP_ECLASS=1

# @ECLASS_VARIABLE: WEBAPP_DEPEND
# @DESCRIPTION:
# An ebuild should use WEBAPP_DEPEND if a custom DEPEND needs to be built, most
# notably in combination with WEBAPP_OPTIONAL.
WEBAPP_DEPEND="app-admin/webapp-config"

# @ECLASS_VARIABLE: WEBAPP_NO_AUTO_INSTALL
# @PRE_INHERIT
# @DESCRIPTION:
# An ebuild sets this to `yes' if an automatic installation and/or upgrade is
# not possible. The ebuild should overwrite pkg_postinst() and explain the
# reason for this BEFORE calling webapp_pkg_postinst().

# @ECLASS_VARIABLE: WEBAPP_OPTIONAL
# @PRE_INHERIT
# @DESCRIPTION:
# An ebuild sets this to `yes' to make webapp support optional, in which case
# you also need to take care of USE-flags and dependencies.

if [[ "${WEBAPP_OPTIONAL}" != "yes" ]]; then
	[[ "${WEBAPP_NO_AUTO_INSTALL}" == "yes" ]] || IUSE="vhosts"
	SLOT="${PVR}"
	DEPEND="${WEBAPP_DEPEND}"
	RDEPEND="${DEPEND}"
fi

INSTALL_DIR="/${PN}"
IS_UPGRADE=0
IS_REPLACE=0

INSTALL_CHECK_FILE="installed_by_webapp_eclass"
SETUP_CHECK_FILE="setup_by_webapp_eclass"

ETC_CONFIG="${ROOT%/}/etc/vhosts/webapp-config"
WEBAPP_CONFIG="${ROOT%/}/usr/sbin/webapp-config"
WEBAPP_CLEANER="${ROOT%/}/usr/sbin/webapp-cleaner"

# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

# Load the config file /etc/vhosts/webapp-config
# Supports both the old bash version, and the new python version
webapp_read_config() {
	debug-print-function $FUNCNAME $*

	if has_version '>=app-admin/webapp-config-1.50'; then
		ENVVAR=$(${WEBAPP_CONFIG} --query ${PN} ${PVR}) || die "Could not read settings from webapp-config!"
		eval ${ENVVAR}
	elif [[ "${WEBAPP_OPTIONAL}" != "yes" ]]; then
		# ETC_CONFIG might not be available
		. ${ETC_CONFIG} || die "Unable to read ${ETC_CONFIG}"
	elif [[ -f "${ETC_CONFIG}" ]]; then
		# WEBAPP_OPTIONAL is set to yes
		# and this must run only if ETC_CONFIG actually exists
		. ${ETC_CONFIG} || die "Unable to read ${ETC_CONFIG}"
	fi
}

# Check whether a specified file exists in the given directory (`.' by default)
webapp_checkfileexists() {
	debug-print-function $FUNCNAME $*

	local my_prefix=${2:+${2}/}

	if [[ ! -e "${my_prefix}${1}" ]]; then
		msg="ebuild fault: file '${1}' not found"
		eerror "$msg"
		eerror "Please report this as a bug at https://bugs.gentoo.org/"
		die "$msg"
	fi
}

webapp_check_installedat() {
	debug-print-function $FUNCNAME $*
	${WEBAPP_CONFIG} --show-installed -h localhost -d "${INSTALL_DIR}" 2> /dev/null
}

webapp_strip_appdir() {
	debug-print-function $FUNCNAME $*
	echo "${1#${MY_APPDIR}/}"
}

webapp_strip_d() {
	debug-print-function $FUNCNAME $*
	echo "${1#${D}}"
}

webapp_strip_cwd() {
	debug-print-function $FUNCNAME $*
	echo "${1/#.\///}"
}

webapp_getinstalltype() {
	debug-print-function $FUNCNAME $*

	if ! has vhosts ${IUSE} || use vhosts; then
		return
	fi

	local my_output
	my_output="$(webapp_check_installedat)"

	if [[ $? -eq 0 ]]; then
		# something is already installed there
		# make sure it isn't the same version

		local my_pn="$(echo ${my_output} | awk '{ print $1 }')"
		local my_pvr="$(echo ${my_output} | awk '{ print $2 }')"

		REMOVE_PKG="${my_pn}-${my_pvr}"

		if [[ "${my_pn}" == "${PN}" ]]; then
			if [[ "${my_pvr}" != "${PVR}" ]]; then
				elog "This is an upgrade"
				IS_UPGRADE=1
				# for binpkgs, reset status, var declared in global scope
				IS_REPLACE=0
			else
				elog "This is a re-installation"
				IS_REPLACE=1
				# for binpkgs, reset status, var declared in global scope
				IS_UPGRADE=0
			fi
		else
			elog "${my_output} is installed there"
		fi
	else
		# for binpkgs, reset status, var declared in global scope
		IS_REPLACE=0
		IS_UPGRADE=0
		elog "This is an installation"
	fi
}

# ==============================================================================
# PUBLIC FUNCTIONS
# ==============================================================================

# @FUNCTION: need_httpd
# @DESCRIPTION:
# Call this function AFTER your ebuilds DEPEND line if any of the available
# webservers are able to run this application.
need_httpd() {
	DEPEND="${DEPEND}
		|| ( virtual/httpd-basic virtual/httpd-cgi virtual/httpd-fastcgi )"
}

# @FUNCTION: need_httpd_cgi
# @DESCRIPTION:
# Call this function AFTER your ebuilds DEPEND line if any of the available
# CGI-capable webservers are able to run this application.
need_httpd_cgi() {
	DEPEND="${DEPEND}
		|| ( virtual/httpd-cgi virtual/httpd-fastcgi )"
}

# @FUNCTION: need_httpd_fastcgi
# @DESCRIPTION:
# Call this function AFTER your ebuilds DEPEND line if any of the available
# FastCGI-capabale webservers are able to run this application.
need_httpd_fastcgi() {
	DEPEND="${DEPEND}
		virtual/httpd-fastcgi"
}

# @FUNCTION: webapp_configfile
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# Mark a file config-protected for a web-based application.
webapp_configfile() {
	debug-print-function $FUNCNAME $*

	local m
	for m in "$@"; do
		webapp_checkfileexists "${m}" "${D}"

		local my_file="$(webapp_strip_appdir "${m}")"
		my_file="$(webapp_strip_cwd "${my_file}")"

		elog "(config) ${my_file}"
		echo "${my_file}" >> "${D}/${WA_CONFIGLIST}"
	done
}

# @FUNCTION: webapp_hook_script
# @USAGE: <file>
# @DESCRIPTION:
# Install a script that will run after a virtual copy is created, and
# before a virtual copy has been removed.
webapp_hook_script() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${1}"

	elog "(hook) ${1}"
	cp "${1}" "${D}/${MY_HOOKSCRIPTSDIR}/$(basename "${1}")" || die "Unable to install ${1} into ${D}/${MY_HOOKSCRIPTSDIR}/"
	chmod 555 "${D}/${MY_HOOKSCRIPTSDIR}/$(basename "${1}")"
}

# @FUNCTION: webapp_postinst_txt
# @USAGE: <lang> <file>
# @DESCRIPTION:
# Install a text file containing post-installation instructions.
webapp_postinst_txt() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${2}"

	elog "(info) ${2} (lang: ${1})"
	cp "${2}" "${D}/${MY_APPDIR}/postinst-${1}.txt"
}

# @FUNCTION: webapp_postupgrade_txt
# @USAGE: <lang> <file>
# @DESCRIPTION:
# Install a text file containing post-upgrade instructions.
webapp_postupgrade_txt() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${2}"

	elog "(info) ${2} (lang: ${1})"
	cp "${2}" "${D}/${MY_APPDIR}/postupgrade-${1}.txt"
}

# helper for webapp_serverowned()
_webapp_serverowned() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${1}" "${D}"
	local my_file="$(webapp_strip_appdir "${1}")"
	my_file="$(webapp_strip_cwd "${my_file}")"

	echo "${my_file}" >> "${D}/${WA_SOLIST}"
}

# @FUNCTION: webapp_serverowned
# @USAGE: [-R] <file> [more files ...]
# @DESCRIPTION:
# Identify a file which must be owned by the webserver's user:group settings.
# The ownership of the file is NOT set until the application is installed using
# the webapp-config tool. If -R is given directories are handled recursively.
webapp_serverowned() {
	debug-print-function $FUNCNAME $*

	local a m
	if [[ "${1}" == "-R" ]]; then
		shift
		for m in "$@"; do
			find "${D}${m}" | while read a; do
				a=$(webapp_strip_d "${a}")
				_webapp_serverowned "${a}"
			done
		done
	else
		for m in "$@"; do
			_webapp_serverowned "${m}"
		done
	fi
}

# @FUNCTION: webapp_server_configfile
# @USAGE: <server> <file> [new name]
# @DESCRIPTION:
# Install a configuration file for the webserver.  You need to specify a
# webapp-config supported <server>.  if no new name is given `basename $2' is
# used by default. Note: this function will automagically prepend $1 to the
# front of your config file's name.
webapp_server_configfile() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${2}"

	# WARNING:
	#
	# do NOT change the naming convention used here without changing all
	# the other scripts that also rely upon these names

	local my_file="${1}-${3:-$(basename "${2}")}"

	elog "(${1}) config file '${my_file}'"
	cp "${2}" "${D}/${MY_SERVERCONFIGDIR}/${my_file}"
}

# @FUNCTION: webapp_sqlscript
# @USAGE: <db> <file> [version]
# @DESCRIPTION:
# Install a SQL script that creates/upgrades a database schema for the web
# application. Currently supported database engines are mysql and postgres.
# If a version is given the script should upgrade the database schema from
# the given version to $PVR.
webapp_sqlscript() {
	debug-print-function $FUNCNAME $*

	webapp_checkfileexists "${2}"

	dodir "${MY_SQLSCRIPTSDIR}/${1}"

	# WARNING:
	#
	# do NOT change the naming convention used here without changing all
	# the other scripts that also rely upon these names

	if [[ -n "${3}" ]]; then
		elog "(${1}) upgrade script for ${PN}-${3} to ${PVR}"
		cp "${2}" "${D}${MY_SQLSCRIPTSDIR}/${1}/${3}_to_${PVR}.sql"
		chmod 600 "${D}${MY_SQLSCRIPTSDIR}/${1}/${3}_to_${PVR}.sql"
	else
		elog "(${1}) create script for ${PN}-${PVR}"
		cp "${2}" "${D}/${MY_SQLSCRIPTSDIR}/${1}/${PVR}_create.sql"
		chmod 600 "${D}/${MY_SQLSCRIPTSDIR}/${1}/${PVR}_create.sql"
	fi
}

# @FUNCTION: webapp_src_preinst
# @DESCRIPTION:
# You need to call this function in src_install() BEFORE anything else has run.
# For now we just create required webapp-config directories.
webapp_src_preinst() {
	debug-print-function $FUNCNAME $*

	# sanity checks, to catch bugs in the ebuild
	if [[ ! -f "${T}/${SETUP_CHECK_FILE}" ]]; then
		eerror
		eerror "This ebuild did not call webapp_pkg_setup() at the beginning"
		eerror "of the pkg_setup() function"
		eerror
		eerror "Please log a bug on https://bugs.gentoo.org"
		eerror
		eerror "You should use emerge -C to remove this package, as the"
		eerror "installation is incomplete"
		eerror
		die "Ebuild did not call webapp_pkg_setup() - report to https://bugs.gentoo.org"
	fi

	# Hint, see the webapp_read_config() function to find where these are
	# defined.
	dodir "${MY_HTDOCSDIR}"
	dodir "${MY_HOSTROOTDIR}"
	dodir "${MY_CGIBINDIR}"
	dodir "${MY_ICONSDIR}"
	dodir "${MY_ERRORSDIR}"
	dodir "${MY_SQLSCRIPTSDIR}"
	dodir "${MY_HOOKSCRIPTSDIR}"
	dodir "${MY_SERVERCONFIGDIR}"
}

# ==============================================================================
# EXPORTED FUNCTIONS
# ==============================================================================

# @FUNCTION: webapp_pkg_setup
# @DESCRIPTION:
# The default pkg_setup() for this eclass. This will gather required variables
# from webapp-config and check if there is an application installed to
# `${ROOT%/}/var/www/localhost/htdocs/${PN}/' if USE=vhosts is not set.
#
# You need to call this function BEFORE anything else has run in your custom
# pkg_setup().
webapp_pkg_setup() {
	debug-print-function $FUNCNAME $*

	# to test whether or not the ebuild has correctly called this function
	# we add an empty file to the filesystem
	#
	# we used to just set a variable in the shell script, but we can
	# no longer rely on Portage calling both webapp_pkg_setup() and
	# webapp_src_install() within the same shell process
	touch "${T}/${SETUP_CHECK_FILE}"

	# special case - some ebuilds *do* need to overwride the SLOT
	if [[ "${SLOT}+" != "${PVR}+" && "${WEBAPP_MANUAL_SLOT}" != "yes" ]]; then
		die "Set WEBAPP_MANUAL_SLOT=\"yes\" if you need to SLOT manually"
	fi

	# pull in the shared configuration file
	G_HOSTNAME="localhost"
	webapp_read_config

	local my_dir="${ROOT%/}/${VHOST_ROOT}/${MY_HTDOCSBASE}/${PN}"

	# if USE=vhosts is enabled OR no application is installed we're done here
	if ! has vhosts ${IUSE} || use vhosts || [[ ! -d "${my_dir}" ]]; then
		return
	fi

	local my_output
	my_output="$(webapp_check_installedat)"

	if [[ $? -ne 0 ]]; then
		# okay, whatever is there, it isn't webapp-config-compatible
		echo
		ewarn
		ewarn "You already have something installed in ${my_dir}"
		ewarn
		ewarn "Whatever is in ${my_dir}, it's not"
		ewarn "compatible with webapp-config."
		ewarn
		ewarn "This ebuild may be overwriting important files."
		ewarn
		echo
	elif [[ "$(echo ${my_output} | awk '{ print $1 }')" != "${PN}" ]]; then
		echo
		eerror "You already have ${my_output} installed in ${my_dir}"
		eerror
		eerror "I cannot upgrade a different application"
		eerror
		echo
		die "Cannot upgrade contents of ${my_dir}"
	fi

}

# @FUNCTION: webapp_src_install
# @DESCRIPTION:
# This is the default src_install(). For now, we just make sure that root owns
# everything, and that there are no setuid files.
#
# You need to call this function AFTER everything else has run in your custom
# src_install().
webapp_src_install() {
	debug-print-function $FUNCNAME $*

	# to test whether or not the ebuild has correctly called this function
	# we add an empty file to the filesystem
	#
	# we used to just set a variable in the shell script, but we can
	# no longer rely on Portage calling both webapp_src_install() and
	# webapp_pkg_postinst() within the same shell process
	touch "${D}/${MY_APPDIR}/${INSTALL_CHECK_FILE}"

	chown -R "${VHOST_DEFAULT_UID}:${VHOST_DEFAULT_GID}" "${D}/"
	chmod -R u-s "${D}/"
	chmod -R g-s "${D}/"

	keepdir "${MY_PERSISTDIR}"
	fowners "0:0" "${MY_PERSISTDIR}"
	fperms 755 "${MY_PERSISTDIR}"
}

# @FUNCTION: webapp_pkg_postinst
# @DESCRIPTION:
# The default pkg_postinst() for this eclass. This installs the web application to
# `${ROOT%/}/var/www/localhost/htdocs/${PN}/' if USE=vhosts is not set. Otherwise
# display a short notice how to install this application with webapp-config.
#
# You need to call this function AFTER everything else has run in your custom
# pkg_postinst().
webapp_pkg_postinst() {
	debug-print-function $FUNCNAME $*

	webapp_read_config

	# sanity checks, to catch bugs in the ebuild
	if [[ ! -f "${ROOT%/}/${MY_APPDIR}/${INSTALL_CHECK_FILE}" ]]; then
		eerror
		eerror "This ebuild did not call webapp_src_install() at the end"
		eerror "of the src_install() function"
		eerror
		eerror "Please log a bug on https://bugs.gentoo.org"
		eerror
		eerror "You should use emerge -C to remove this package, as the"
		eerror "installation is incomplete"
		eerror
		die "Ebuild did not call webapp_src_install() - report to https://bugs.gentoo.org"
	fi

	if has vhosts ${IUSE}; then
		if ! use vhosts; then
			echo
			elog "vhosts USE flag not set - auto-installing using webapp-config"

			G_HOSTNAME="localhost"
			webapp_read_config

			local my_mode=-I
			webapp_getinstalltype

			if [[ "${IS_REPLACE}" == "1" ]]; then
				elog "${PN}-${PVR} is already installed - replacing"
				my_mode=-I
			elif [[ "${IS_UPGRADE}" == "1" ]]; then
				elog "${REMOVE_PKG} is already installed - upgrading"
				my_mode=-U
			else
				elog "${PN}-${PVR} is not installed - using install mode"
			fi

			my_cmd="${WEBAPP_CONFIG} -h localhost -u root -d ${INSTALL_DIR} ${my_mode} ${PN} ${PVR}"
			elog "Running ${my_cmd}"
			${my_cmd}

			echo
			local cleaner="${WEBAPP_CLEANER} -p -C ${CATEGORY}/${PN}"
			einfo "Running ${cleaner}"
			${cleaner}
		else
			elog
			elog "The 'vhosts' USE flag is switched ON"
			elog "This means that Portage will not automatically run webapp-config to"
			elog "complete the installation."
			elog
			elog "To install ${PN}-${PVR} into a virtual host, run the following command:"
			elog
			elog "    webapp-config -h <host> -d ${PN} -I ${PN} ${PVR}"
			elog
			elog "For more details, see the webapp-config(8) man page"
		fi
	else
		elog
		elog "This ebuild does not support the 'vhosts' USE flag."
		elog "This means that Portage will not automatically run webapp-config to"
		elog "complete the installation."
		elog
		elog "To install ${PN}-${PVR} into a virtual host, run the following command:"
		elog
		elog "    webapp-config -h <host> -d ${PN} -I ${PN} ${PVR}"
		elog
		elog "For more details, see the webapp-config(8) man page"
	fi
}

# @FUNCTION: webapp_pkg_prerm
# @DESCRIPTION:
# This is the default pkg_prerm() for this eclass. If USE=vhosts is not set
# remove all installed copies of this web application. Otherwise instruct the
# user to manually remove those copies. See bug #136959.
webapp_pkg_prerm() {
	debug-print-function $FUNCNAME $*

	local my_output=
	my_output="$(${WEBAPP_CONFIG} --list-installs ${PN} ${PVR})"
	[[ $? -ne 0 ]] && return

	local x
	if has vhosts ${IUSE} && ! use vhosts; then
		echo "${my_output}" | while read x; do
			if [[ -f "${x}"/.webapp ]]; then
				. "${x}"/.webapp
				if [[ -n "${WEB_HOSTNAME}" && -n "${WEB_INSTALLDIR}" ]]; then
					${WEBAPP_CONFIG} -h ${WEB_HOSTNAME} -d ${WEB_INSTALLDIR} -C ${PN} ${PVR}
				fi
			else
				ewarn "Cannot find file ${x}/.webapp"
			fi
		done
	elif [[ "${my_output}" != "" ]]; then
		echo
		ewarn
		ewarn "Don't forget to use webapp-config to remove any copies of"
		ewarn "${PN}-${PVR} installed in"
		ewarn

		echo "${my_output}" | while read x; do
			if [[ -f "${x}"/.webapp ]]; then
				ewarn "    ${x}"
			else
				ewarn "Cannot find file ${x}/.webapp"
			fi
		done

		ewarn
		echo
	fi
}

fi

EXPORT_FUNCTIONS pkg_postinst pkg_setup src_install pkg_prerm
