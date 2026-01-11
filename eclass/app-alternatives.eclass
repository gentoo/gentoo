# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: app-alternatives.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Common logic for app-alternatives/*
# @DESCRIPTION:
# This eclass provides common logic shared by app-alternatives/*
# ebuilds.  A global ALTERNATIVES variable needs to be declared
# that lists available options and their respective dependencies.
# HOMEPAGE, S, LICENSE, SLOT, IUSE, REQUIRED_USE and RDEPEND are set.
# A get_alternative() function is provided that determines the selected
# alternative and prints its respective flag name.

if [[ -z ${_APP_ALTERNATIVES_ECLASS} ]]; then
_APP_ALTERNATIVES_ECLASS=1

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} unsupported."
esac

# @ECLASS_VARIABLE: ALTERNATIVES
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Array of "flag:dependency" pairs specifying the available
# alternatives.  The default provider must be listed first.

# @FUNCTION: _app-alternatives_set_globals
# @INTERNAL
# @DESCRIPTION:
# Set ebuild metadata variables.
_app-alternatives_set_globals() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${ALTERNATIVES@a} != *a* ]]; then
		die 'ALTERNATIVES must be an array.'
	elif [[ ${#ALTERNATIVES[@]} -eq 0 ]]; then
		die 'ALTERNATIVES must not be empty.'
	fi

	HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
	S=${WORKDIR}

	LICENSE="CC0-1.0"
	SLOT="0"

	# yep, that's a cheap hack adding '+' to the first flag
	IUSE="+${ALTERNATIVES[*]%%:*}"
	REQUIRED_USE="^^ ( ${ALTERNATIVES[*]%%:*} )"
	RDEPEND=""

	local flag dep
	for flag in "${ALTERNATIVES[@]}"; do
		[[ ${flag} != *:* ]] && die "Invalid ALTERNATIVES item: ${flag}"
		dep=${flag#*:}
		flag=${flag%%:*}
		RDEPEND+="
			${flag}? ( ${dep} )
		"
	done
}
_app-alternatives_set_globals

# @FUNCTION: get_alternative
# @DESCRIPTION:
# Get the flag name for the selected alternative (i.e. the USE flag set).
get_alternative() {
	debug-print-function ${FUNCNAME} "$@"

	local flag
	for flag in "${ALTERNATIVES[@]%%:*}"; do
		usev "${flag}" && return
	done

	die "No selected alternative found (REQUIRED_USE ignored?!)"
}

fi
