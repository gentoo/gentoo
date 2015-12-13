# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: readme.gentoo.eclass
# @MAINTAINER:
# Pacho Ramos <pacho@gentoo.org>
# @AUTHOR:
# Author: Pacho Ramos <pacho@gentoo.org>
# @BLURB: An eclass for installing a README.gentoo doc file recording tips
# shown via elog messages.
# @DESCRIPTION:
# An eclass for installing a README.gentoo doc file recording tips
# shown via elog messages. With this eclass, those elog messages will only be
# shown at first package installation and a file for later reviewing will be
# installed under /usr/share/doc/${PF}
#
# You need to call readme.gentoo_create_doc in src_install phase and
# readme.gentoo_print_elog in pkg_postinst

if [[ -z ${_README_GENTOO_ECLASS} ]]; then
_README_GENTOO_ECLASS=1

inherit eutils

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS-VARIABLE: DISABLE_AUTOFORMATTING
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty, DOC_CONTENTS information will be strictly respected,
# not getting it automatically formatted by fmt. If empty, it will
# rely on fmt for formatting and 'echo -e' options to tweak lines a bit.

# @ECLASS-VARIABLE: FORCE_PRINT_ELOG
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable forces elog messages to be printed.

# @ECLASS-VARIABLE: README_GENTOO_SUFFIX
# @DESCRIPTION:
# If you want to specify a suffix for README.gentoo file please export it.
: ${README_GENTOO_SUFFIX:=""}

# @FUNCTION: readme.gentoo_create_doc
# @DESCRIPTION:
# Create doc file with ${DOC_CONTENTS} variable (preferred) and, if not set,
# look for "${FILESDIR}/README.gentoo" contents. You can use
# ${FILESDIR}/README.gentoo-${SLOT} also.
# Usually called at src_install phase.
readme.gentoo_create_doc() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -n "${DOC_CONTENTS}" ]]; then
		eshopts_push
		set -f
		if [[ -n "${DISABLE_AUTOFORMATTING}" ]]; then
			echo "${DOC_CONTENTS}" > "${T}"/README.gentoo
		else
			echo -e ${DOC_CONTENTS} | fold -s -w 70 \
				| sed 's/[[:space:]]*$//' > "${T}"/README.gentoo
		fi
		eshopts_pop
	elif [[ -f "${FILESDIR}/README.gentoo-${SLOT%/*}" ]]; then
		cp "${FILESDIR}/README.gentoo-${SLOT%/*}" "${T}"/README.gentoo || die
	elif [[ -f "${FILESDIR}/README.gentoo${README_GENTOO_SUFFIX}" ]]; then
		cp "${FILESDIR}/README.gentoo${README_GENTOO_SUFFIX}" "${T}"/README.gentoo || die
	else
		die "You are not specifying README.gentoo contents!"
	fi

	dodoc "${T}"/README.gentoo
	README_GENTOO_DOC_VALUE=$(< "${T}/README.gentoo")
}

# @FUNCTION: readme.gentoo_print_elog
# @DESCRIPTION:
# Print elog messages with "${T}"/README.gentoo contents. They will be
# shown only when package is installed at first time.
# Usually called at pkg_postinst phase.
#
# If you want to show them always, please set FORCE_PRINT_ELOG to a non empty
# value in your ebuild before this function is called.
# This can be useful when, for example, DOC_CONTENTS is modified, then, you can
# rely on specific REPLACING_VERSIONS handling in your ebuild to print messages
# when people update from versions still providing old message.
readme.gentoo_print_elog() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z "${README_GENTOO_DOC_VALUE}" ]]; then
		die "readme.gentoo_print_elog invoked without matching readme.gentoo_create_doc call!"
	elif ! [[ -n "${REPLACING_VERSIONS}" ]] || [[ -n "${FORCE_PRINT_ELOG}" ]]; then
		echo -e "${README_GENTOO_DOC_VALUE}" | while read -r ELINE; do elog "${ELINE}"; done
		elog ""
		elog "(Note: Above message is only printed the first time package is"
		elog "installed. Please look at ${EPREFIX}/usr/share/doc/${PF}/README.gentoo*"
		elog "for future reference)"
	fi
}

fi
