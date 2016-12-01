# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: tmpfiles.eclass
# @MAINTAINER:
# Gentoo systemd project <systemd@gentoo.org>
# William Hubbs <williamh@gentoo.org>
# @AUTHOR:
# Mike Gilbert <floppym@gentoo.org>
# William Hubbs <williamh@gentoo.org>
# @BLURB: Functions related to tmpfiles.d files
# @DESCRIPTION:
# This eclass provides functionality related to installing and
# creating volatile and temporary files based on configuration files$and
# locations defined at this URL:
#
# https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
#
# The dotmpfiles and newtmpfiles functions are used to install
# configuration files into /usr/lib/tmpfiles.d, then in pkg_postinst, the
# tmpfiles_process function can be called to process the newly
# installed tmpfiles.d entries.
#
# @EXAMPLE:
# Typical usage of this eclass:
#
# @CODE
#	EAPI=6
#	inherit tmpfiles
#
#	...
#
#	src_install() {
#		...
#		dotmpfiles "${FILESDIR}"/file1.conf "${FILESDIR}"/file2.conf
#		newtmpfiles "${FILESDIR}"/file3.conf-${PV} file3.conf
#		...
#	}
#
#	pkg_postinst() {
#		...
#		tmpfiles_process file1.conf file2.conf file3.conf
#		...
#	}
#
# @CODE

if [[ -z ${TMPFILES_ECLASS} ]]; then
TMPFILES_ECLASS=1

case "${EAPI}" in
6) ;;
*) die "API is undefined for EAPI ${EAPI}" ;;
esac

RDEPEND="kernel_linux? ( virtual/tmpfiles )"

# @FUNCTION: dotmpfiles
# @USAGE: dotmpfiles <tmpfiles.d_file> ...
# @DESCRIPTION:
# Install one or more tmpfiles.d files into /usr/lib/tmpfiles.d.
dotmpfiles() {
	debug-print-function "${FUNCNAME}" "$@"

	use kernel_linux || return 0
	local f
	for f; do
		if [[ ${f} != *.conf ]]; then
			die "tmpfiles.d files must end with .conf"
		fi
	done

	(
		insinto /usr/lib/tmpfiles.d
		doins "$@"
	)
}

# @FUNCTION: newtmpfiles
# @USAGE: newtmpfiles <old-name> <new-name>.conf
# @DESCRIPTION:
# Install a tmpfiles.d file in /usr/lib/tmpfiles.d under a new name.
newtmpfiles() {
	debug-print-function "${FUNCNAME}" "$@"

	use kernel_linux || return 0
	if [[ $2 != *.conf ]]; then
		die "tmpfiles.d files must end with .conf"
	fi

	(
		insinto /usr/lib/tmpfiles.d
		newins "$@"
	)
}

# @FUNCTION: tmpfiles_process
# @USAGE: tmpfiles_process <filename> <filename> ...
# @DESCRIPTION:
# Call a tmpfiles.d implementation to create new volatile and temporary
# files and directories.
tmpfiles_process() {
	debug-print-function "${FUNCNAME}" "$@"

	use kernel_linux || return 0
	[[ ${EBUILD_PHASE} == postinst ]] || die "${FUNCNAME}: Only valid in pkg_postinst"
	[[ ${#} -gt 0 ]] || die "${FUNCNAME}: Must specify at least one filename"

	# Only process tmpfiles for the currently running system
	[[ ${ROOT} == / ]] || return 0

	if type systemd-tmpfiles &> /dev/null; then
		systemd-tmpfiles --create "$@"
	elif type opentmpfiles &> /dev/null; then
		opentmpfiles --create "$@"
	fi
	if [[ $? -ne 0 ]]; then
		ewarn "The tmpfiles processor exited with a non-zero exit code"
	fi
}

fi
