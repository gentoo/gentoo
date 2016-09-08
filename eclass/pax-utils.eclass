# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: pax-utils.eclass
# @MAINTAINER:
# The Gentoo Linux Hardened Team <hardened@gentoo.org>
# @AUTHOR:
# Author: Kevin F. Quinn <kevquinn@gentoo.org>
# Author: Anthony G. Basile <blueness@gentoo.org>
# @BLURB: functions to provide PaX markings for hardened kernels
# @DESCRIPTION:
#
# This eclass provides support for manipulating PaX markings on ELF binaries,
# whether the system is using legacy PT_PAX markings or the newer XATTR_PAX.
# The eclass wraps the use of paxctl-ng, paxctl, set/getattr and scanelf utilities,
# deciding which to use depending on what's installed on the build host, and
# whether we're working with PT_PAX, XATTR_PAX or both.
#
# To control what markings are made, set PAX_MARKINGS in /etc/portage/make.conf
# to contain either "PT", "XT" or "none".  The default is to attempt both
# PT_PAX and XATTR_PAX.

if [[ -z ${_PAX_UTILS_ECLASS} ]]; then
_PAX_UTILS_ECLASS=1

# @ECLASS-VARIABLE: PAX_MARKINGS
# @DESCRIPTION:
# Control which markings are made:
# PT = PT_PAX markings, XT = XATTR_PAX markings
# Default to PT markings.
PAX_MARKINGS=${PAX_MARKINGS:="PT XT"}

# @FUNCTION: pax-mark
# @USAGE: <flags> <ELF files>
# @RETURN: Shell true if we succeed, shell false otherwise
# @DESCRIPTION:
# Marks <ELF files> with provided PaX <flags>
#
# Flags are passed directly to the utilities unchanged.
#
# @CODE
#	p: disable PAGEEXEC		P: enable PAGEEXEC
#	e: disable EMUTRAMP		E: enable EMUTRAMP
#	m: disable MPROTECT		M: enable MPROTECT
#	r: disable RANDMMAP		R: enable RANDMMAP
#	s: disable SEGMEXEC		S: enable SEGMEXEC
# @CODE
#
# Default flags are 'PeMRS', which are the most restrictive settings.  Refer
# to http://pax.grsecurity.net/ for details on what these flags are all about.
#
# Please confirm any relaxation of restrictions with the Gentoo Hardened team.
# Either ask on the gentoo-hardened mailing list, or CC/assign hardened@g.o on
# the bug report.
pax-mark() {
	local f								# loop over paxables
	local flags							# pax flags
	local ret=0							# overall return code of this function

	# Only the actual PaX flags and z are accepted
	# 1. The leading '-' is optional
	# 2. -C -c only make sense for paxctl, but are unnecessary
	#    because we progressively do -q -qc -qC
	# 3. z is allowed for the default

	flags="${1//[!zPpEeMmRrSs]}"
	[[ "${flags}" ]] || return 0
	shift

	# z = default. For XATTR_PAX, the default is no xattr field at all
	local dodefault=""
	[[ "${flags//[!z]}" ]] && dodefault="yes"

	if has PT ${PAX_MARKINGS}; then
		# Uncomment to list all files to be marked
		# _pax_list_files einfo "$@"
		for f in "$@"; do

			# First try paxctl
			if type -p paxctl >/dev/null; then
				einfo "PT_PAX marking -${flags} ${f} with paxctl"
				# We try modifying the existing PT_PAX_FLAGS header.
				paxctl -q${flags} "${f}" >/dev/null 2>&1 && continue
				# We no longer try to create/convert a PT_PAX_FLAGS header, bug #590422
				# paxctl -qC${flags} "${f}" >/dev/null 2>&1 && continue
				# paxctl -qc${flags} "${f}" >/dev/null 2>&1 && continue
			fi

			# Next try paxctl-ng -> this will not create/convert any program headers.
			if type -p paxctl-ng >/dev/null && paxctl-ng -L ; then
				einfo "PT_PAX marking -${flags} ${f} with paxctl-ng"
				flags="${flags//z}"
				[[ ${dodefault} == "yes" ]] && paxctl-ng -L -z "${f}" >/dev/null 2>&1
				[[ "${flags}" ]] || continue
				paxctl-ng -L -${flags} "${f}" >/dev/null 2>&1 && continue
			fi

			# Finally fall back on scanelf.
			if type -p scanelf >/dev/null && [[ ${PAX_MARKINGS} != "none" ]]; then
				einfo "PT_PAX marking -${flags} ${f} with scanelf"
				scanelf -Xxz ${flags} "$f" >/dev/null 2>&1
			# We failed to set PT_PAX flags.
			elif [[ ${PAX_MARKINGS} != "none" ]]; then
				elog "Failed to set PT_PAX markings -${flags} ${f}."
				ret=1
			fi
		done
	fi

	if has XT ${PAX_MARKINGS}; then
		# Uncomment to list all files to be marked
		# _pax_list_files einfo "$@"
		flags="${flags//z}"
		for f in "$@"; do

			# First try paxctl-ng.
			if type -p paxctl-ng >/dev/null && paxctl-ng -l ; then
				einfo "XATTR_PAX marking -${flags} ${f} with paxctl-ng"
				[[ ${dodefault} == "yes" ]] && paxctl-ng -d "${f}" >/dev/null 2>&1
				[[ "${flags}" ]] || continue
				paxctl-ng -l -${flags} "${f}" >/dev/null 2>&1 && continue
			fi

			# Next try setfattr.
			if type -p setfattr >/dev/null; then
				[[ "${flags//[!Ee]}" ]] || flags+="e" # bug 447150
				einfo "XATTR_PAX marking -${flags} ${f} with setfattr"
				[[ ${dodefault} == "yes" ]] && setfattr -x "user.pax.flags" "${f}" >/dev/null 2>&1
				setfattr -n "user.pax.flags" -v "${flags}" "${f}" >/dev/null 2>&1 && continue
			fi

			# We failed to set XATTR_PAX flags.
			if [[ ${PAX_MARKINGS} != "none" ]]; then
				elog "Failed to set XATTR_PAX markings -${flags} ${f}."
				ret=1
			fi
		done
	fi

	# [[ ${ret} == 1 ]] && elog "Executables may be killed by PaX kernels."

	return ${ret}
}

# @FUNCTION: list-paxables
# @USAGE: <files>
# @RETURN: Subset of <files> which are ELF executables or shared objects
# @DESCRIPTION:
# Print to stdout all of the <files> that are suitable to have PaX flag
# markings, i.e., filter out the ELF executables or shared objects from a list
# of files.  This is useful for passing wild-card lists to pax-mark, although
# in general it is preferable for ebuilds to list precisely which ELFS are to
# be marked.  Often not all the ELF installed by a package need remarking.
# @EXAMPLE:
# pax-mark -m $(list-paxables ${S}/{,usr/}bin/*)
list-paxables() {
	file "$@" 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//'
}

# @FUNCTION: host-is-pax
# @RETURN: Shell true if the build process is PaX enabled, shell false otherwise
# @DESCRIPTION:
# This is intended for use where the build process must be modified conditionally
# depending on whether the host is PaX enabled or not.  It is not indented to
# determine whether the final binaries need PaX markings.  Note: if procfs is
# not mounted on /proc, this returns shell false (e.g. Gentoo/FreeBSD).
host-is-pax() {
	grep -qs ^PaX: /proc/self/status
}


# INTERNAL FUNCTIONS
# ------------------
#
# These functions are for use internally by the eclass - do not use
# them elsewhere as they are not supported (i.e. they may be removed
# or their function may change arbitrarily).

# Display a list of things, one per line, indented a bit, using the
# display command in $1.
_pax_list_files() {
	local f cmd
	cmd=$1
	shift
	for f in "$@"; do
		${cmd} "     ${f}"
	done
}

fi
