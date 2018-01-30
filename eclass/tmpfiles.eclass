# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
# configuration files into /usr/lib/tmpfiles.d, then in pkg_postinst,
# the tmpfiles_process function must be called to process the newly
# installed tmpfiles.d entries.
#
# The tmpfiles.d files can be used by service managers to recreate/clean
# up temporary directories on boot or periodically. Additionally,
# the pkg_postinst() call ensures that the directories are created
# on systems that do not support tmpfiles.d natively, without a need
# for explicit fallback.
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
5|6) ;;
*) die "API is undefined for EAPI ${EAPI}" ;;
esac

RDEPEND="virtual/tmpfiles"

# @FUNCTION: dotmpfiles
# @USAGE: dotmpfiles <tmpfiles.d_file> ...
# @DESCRIPTION:
# Install one or more tmpfiles.d files into /usr/lib/tmpfiles.d.
dotmpfiles() {
	debug-print-function "${FUNCNAME}" "$@"

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

	[[ ${EBUILD_PHASE} == postinst ]] || die "${FUNCNAME}: Only valid in pkg_postinst"
	[[ ${#} -gt 0 ]] || die "${FUNCNAME}: Must specify at least one filename"

	# Only process tmpfiles for the currently running system
	if [[ ${ROOT} != / ]]; then
		ewarn "Warning: tmpfiles.d not processed on ROOT != /. If you do not use"
		ewarn "a service manager supporting tmpfiles.d, you need to run"
		ewarn "the following command after booting (or chroot-ing with all"
		ewarn "appropriate filesystems mounted) into the ROOT:"
		ewarn
		ewarn "  tmpfiles --create"
		ewarn
		ewarn "Failure to do so may result in missing runtime directories"
		ewarn "and failures to run programs or start services."
		return
	fi

	if type systemd-tmpfiles &> /dev/null; then
		systemd-tmpfiles --create "$@"
	elif type tmpfiles &> /dev/null; then
		tmpfiles --create "$@"
	fi
	if [[ $? -ne 0 ]]; then
		ewarn "The tmpfiles processor exited with a non-zero exit code"
	fi
}

fi
