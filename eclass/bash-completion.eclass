# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/bash-completion.eclass,v 1.29 2013/07/05 17:39:10 ulm Exp $

# DEPRECATED
# This eclass has been superseded by bash-completion-r1 eclass.
# Please modify your ebuilds to use that one instead.

# @ECLASS: bash-completion.eclass
# @MAINTAINER:
# shell-tools@gentoo.org.
# @AUTHOR:
# Original author: Aaron Walker <ka0ttic@gentoo.org>
# @BLURB: An Interface for installing contributed bash-completion scripts
# @DESCRIPTION:
# Simple eclass that provides an interface for installing
# contributed (ie not included in bash-completion proper)
# bash-completion scripts.
#
# Note: this eclass has been deprecated in favor of bash-completion-r1. Please
# use that one instead.

# @ECLASS-VARIABLE: BASHCOMPLETION_NAME
# @DESCRIPTION:
# Install the completion script with this name (see also dobashcompletion)

# @ECLASS-VARIABLE: BASHCOMPFILES
# @DESCRIPTION:
# Space delimited list of files to install if dobashcompletion is called without
# arguments.

inherit eutils

EXPORT_FUNCTIONS pkg_postinst

IUSE="bash-completion"

# Allow eclass to be inherited by eselect without a circular dependency
if [[ ${CATEGORY}/${PN} != app-admin/eselect ]]; then
	RDEPEND="bash-completion? ( app-admin/eselect )"
fi
PDEPEND="bash-completion? ( app-shells/bash-completion )"

# @FUNCTION: dobashcompletion
# @USAGE: [file] [new_file]
# @DESCRIPTION:
# The first argument is the location of the bash-completion script to install,
# and is required if BASHCOMPFILES is not set. The second argument is the name
# the script will be installed as. If BASHCOMPLETION_NAME is set, it overrides
# the second argument. If no second argument is given and BASHCOMPLETION_NAME
# is not set, it will default to ${PN}.
dobashcompletion() {
	local f

	eqawarn "bash-completion.eclass has been deprecated."
	eqawarn "Please update your ebuilds to use bash-completion-r1 instead."

	if [[ -z ${1} && -z ${BASHCOMPFILES} ]]; then
		die "Usage: dobashcompletion [file] [new file]"
	fi

	if use bash-completion; then
		insinto /usr/share/bash-completion
		if [[ -n ${1} ]]; then
			[[ -z ${BASHCOMPLETION_NAME} ]] && BASHCOMPLETION_NAME="${2:-${PN}}"
			newins "${1}" "${BASHCOMPLETION_NAME}" || die "Failed to install ${1}"
		else
			set -- ${BASHCOMPFILES}
			for f in "$@"; do
				if [[ -e ${f} ]]; then
					doins "${f}" || die "Failed to install ${f}"
				fi
			done
		fi
	fi
}

# @FUNCTION: bash-completion_pkg_postinst
# @DESCRIPTION:
# The bash-completion pkg_postinst function, which is exported
bash-completion_pkg_postinst() {
	local f

	if use bash-completion ; then
		elog "The following bash-completion scripts have been installed:"
		if [[ -n ${BASHCOMPLETION_NAME} ]]; then
			elog "	${BASHCOMPLETION_NAME}"
		else
			set -- ${BASHCOMPFILES}
			for f in "$@"; do
				elog "	$(basename ${f})"
			done
		fi
		elog
		elog "To enable command-line completion on a per-user basis run:"
		elog "	eselect bashcomp enable <script>"
		elog
		elog "To enable command-line completion system-wide run:"
		elog "	eselect bashcomp enable --global <script>"
	fi
}
