# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: optfeature.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Advertise optional functionality that might be useful to users

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI=${EAPI:-0} is not supported" ;;
esac

if [[ -z ${_OPTFEATURE_ECLASS} ]]; then
_OPTFEATURE_ECLASS=1

# @ECLASS_VARIABLE: _OPTFEATURE_DEFAULT_HEADER
# @INTERNAL
# @DESCRIPTION:
# Default header printed ahead of optfeature output. Can be overridden
# by calling optfeature_header function. Will not be displayed if all optional
# dependencies are present.
_OPTFEATURE_DEFAULT_HEADER="Install additional packages for optional runtime features:"

readonly _OPTFEATURE_DEFAULT_HEADER

# @ECLASS_VARIABLE: _OPTFEATURE_HEADER
# @INTERNAL
# @DESCRIPTION:
# Default empty. Custom header printed ahead of optfeature output.
# Set by calling optfeature_header function with the desired output, or reset
# by optfeature_header without argument. Will not be displayed if all optional
# dependencies are present.
_OPTFEATURE_HEADER=

# @ECLASS_VARIABLE: _OPTFEATURE_DOHEADER
# @INTERNAL
# @DESCRIPTION:
# If true, print header ahead of the first optfeature output.
_OPTFEATURE_DOHEADER=true

# @FUNCTION: optfeature_header
# @USAGE: [custom header for follow-up optfeature calls]
# @DESCRIPTION:
# Set a custom header for follow-up optfeature calls, or reset to default
# header by calling it without argument. This can not only be used to customize
# the header but also to distinguish optfeature "groups", e.g. to list a number
# of different possible database backends, and then a number of optional
# regular runtime features.
#
# The following snippet will leave the default header untouched for the first
# two optfeature calls. Then a custom header is set that is going to be
# displayed in case dev-db/a or dev-db/b are not installed.
# @CODE
# pkg_postinst() {
# 	optfeature "foo support" app-misc/foo
# 	optfeature "bar support" app-misc/bar
# 	optfeature_header "Install optional database backends:"
# 	optfeature "a DB backend" dev-db/a
# 	optfeature "b DB backend" dev-db/b
# }
# @CODE
optfeature_header() {
	debug-print-function ${FUNCNAME} "$@"
	_OPTFEATURE_HEADER="${1}"
	_OPTFEATURE_DOHEADER=true
}

# @FUNCTION: optfeature
# @USAGE: <short description> <package atom to match> [other atoms]
# @DESCRIPTION:
# Print out a message suggesting an optional package (or packages)
# not currently installed which provides the described functionality.
#
# The following snippet would suggest app-misc/foo for optional foo support,
# app-misc/bar or app-misc/baz[bar] for optional bar support
# and either both app-misc/a and app-misc/b or app-misc/c for alphabet support.
# @CODE
# pkg_postinst() {
# 	optfeature "foo support" app-misc/foo
# 	optfeature "bar support" app-misc/bar app-misc/baz[bar]
# 	optfeature "alphabet support" "app-misc/a app-misc/b" app-misc/c
# }
# @CODE
optfeature() {
	debug-print-function ${FUNCNAME} "$@"

	local i j msg
	local -a arr
	local desc=$1
	local flag=0
	shift
	for i; do
		read -r -d '' -a arr <<<"${i}"
		for j in "${arr[@]}"; do
			if has_version "${j}"; then
				flag=1
			else
				flag=0
				break
			fi
		done
		if [[ ${flag} -eq 1 ]]; then
			break
		fi
	done
	if [[ ${flag} -eq 0 ]]; then
		if [[ ${_OPTFEATURE_DOHEADER} == true ]]; then
			elog ${_OPTFEATURE_HEADER:-${_OPTFEATURE_DEFAULT_HEADER}}
			_OPTFEATURE_DOHEADER=false
		fi
		for i; do
			read -r -d '' -a arr <<<"${i}"
			msg=" "
			for j in "${arr[@]}"; do
				msg+=" ${j} and"
			done
			msg="${msg:0: -4} for ${desc}"
			elog "${msg}"
		done
	fi
}

fi
