# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: optfeature.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: Advertise optional functionality that might be useful to users

case ${EAPI:-0} in
	[0-7]) ;;
	*)     die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

if [[ -z ${_OPTFEATURE_ECLASS} ]]; then
_OPTFEATURE_ECLASS=1

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
#	optfeature "foo support" app-misc/foo
#	optfeature "bar support" app-misc/bar app-misc/baz[bar]
#	optfeature "alphabet support" "app-misc/a app-misc/b" app-misc/c
# @CODE
optfeature() {
	debug-print-function ${FUNCNAME} "$@"

	local i j msg
	local desc=$1
	local flag=0
	shift
	for i; do
		for j in ${i}; do
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
		for i; do
			msg=" "
			for j in ${i}; do
				msg+=" ${j} and"
			done
			msg="${msg:0: -4} for ${desc}"
			elog "${msg}"
		done
	fi
}

fi
