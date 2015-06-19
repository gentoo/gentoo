# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/bash-completion-r1.eclass,v 1.14 2014/09/02 15:28:05 mgorny Exp $

# @ECLASS: bash-completion-r1.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @BLURB: A few quick functions to install bash-completion files
# @EXAMPLE:
#
# @CODE
# EAPI=5
#
# src_configure() {
# 	econf \
#		--with-bash-completion-dir="$(get_bashcompdir)"
# }
#
# src_install() {
# 	default
#
# 	newbashcomp contrib/${PN}.bash-completion ${PN}
# }
# @CODE

inherit toolchain-funcs

case ${EAPI:-0} in
	0|1|2|3|4|5) ;;
	*) die "EAPI ${EAPI} unsupported (yet)."
esac

# @FUNCTION: _bash-completion-r1_get_bashdir
# @INTERNAL
# @DESCRIPTION:
# First argument is name of the string in bash-completion.pc
# Second argument is the fallback directory if the string is not found
# @EXAMPLE:
# _bash-completion-r1_get_bashdir completionsdir /usr/share/bash-completion
_bash-completion-r1_get_bashdir() {
	debug-print-function ${FUNCNAME} "${@}"

	if $(tc-getPKG_CONFIG) --exists bash-completion &>/dev/null; then
		local path="$($(tc-getPKG_CONFIG) --variable=$1 bash-completion)"
		# we need to return unprefixed, so strip from what pkg-config returns
		# to us, bug #477692
		echo "${path#${EPREFIX}}"
	else
		echo $2
	fi
}

# @FUNCTION: _bash-completion-r1_get_bashcompdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed bash-completion completions directory.
_bash-completion-r1_get_bashcompdir() {
	debug-print-function ${FUNCNAME} "${@}"

	_bash-completion-r1_get_bashdir completionsdir /usr/share/bash-completion/completions
}

# @FUNCTION: _bash-completion-r1_get_helpersdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed bash-completion helpers directory.
_bash-completion-r1_get_bashhelpersdir() {
	debug-print-function ${FUNCNAME} "${@}"

	_bash-completion-r1_get_bashdir helpersdir /usr/share/bash-completion/helpers
}

# @FUNCTION: get_bashcompdir
# @DESCRIPTION:
# Get the bash-completion completions directory.
get_bashcompdir() {
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_bash-completion-r1_get_bashcompdir)"
}

# @FUNCTION: get_bashhelpersdir
# @INTERNAL
# @DESCRIPTION:
# Get the bash-completion helpers directory.
get_bashhelpersdir() {
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_bash-completion-r1_get_bashhelpersdir)"
}

# @FUNCTION: dobashcomp
# @USAGE: file [...]
# @DESCRIPTION:
# Install bash-completion files passed as args. Has EAPI-dependant failure
# behavior (like doins).
dobashcomp() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insinto "$(_bash-completion-r1_get_bashcompdir)"
		doins "${@}"
	)
}

# @FUNCTION: newbashcomp
# @USAGE: file newname
# @DESCRIPTION:
# Install bash-completion file under a new name. Has EAPI-dependant failure
# behavior (like newins).
newbashcomp() {
	debug-print-function ${FUNCNAME} "${@}"

	(
		insinto "$(_bash-completion-r1_get_bashcompdir)"
		newins "${@}"
	)
}

# @FUNCTION: bashcomp_alias
# @USAGE: <basename> <alias>...
# @DESCRIPTION:
# Alias <basename> completion to one or more commands (<alias>es).
bashcomp_alias() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -lt 2 ]] && die "Usage: ${FUNCNAME} <basename> <alias>..."
	local base=${1} f
	shift

	for f; do
		dosym "${base}" "$(_bash-completion-r1_get_bashcompdir)/${f}"
	done
}
