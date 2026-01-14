# Copyright 2004-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: strip-linguas.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Mike Frysinger <vapier@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: convenience function for LINGUAS support

if [[ -z ${_STRIP_LINGUAS_ECLASS} ]]; then
_STRIP_LINGUAS_ECLASS=1

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: strip-linguas
# @USAGE: [<allow LINGUAS>|<-i|-u> <directories of .po files>]
# @DESCRIPTION:
# Make sure that LINGUAS only contains languages that a package can
# support.  The first form allows you to specify a list of LINGUAS.
# The -i builds a list of po files found in all the directories and uses
# the intersection of the lists.  The -u builds a list of po files found
# in all the directories and uses the union of the lists.
strip-linguas() {
	local d f ls newls nols

	if [[ $1 == "-i" ]] || [[ $1 == "-u" ]]; then
		local op=$1; shift
		ls=$(find "$1" -name '*.po' -exec basename {} .po ';'); shift
		for d; do
			if [[ ${op} == "-u" ]]; then
				newls=${ls}
			else
				newls=""
			fi
			for f in $(find "${d}" -name '*.po' -exec basename {} .po ';'); do
				if [[ ${op} == "-i" ]]; then
					has ${f} ${ls} && newls+=" ${f}"
				else
					has ${f} ${ls} || newls+=" ${f}"
				fi
			done
			ls=${newls}
		done
	else
		ls="$@"
	fi

	nols=""
	newls=""
	for f in ${LINGUAS}; do
		if has ${f} ${ls}; then
			newls+=" ${f}"
		else
			nols+=" ${f}"
		fi
	done
	[[ -n ${nols} ]] \
		&& einfo "Sorry, but ${PN} does not support the LINGUAS:" ${nols}
	export LINGUAS=${newls:1}
}

fi
