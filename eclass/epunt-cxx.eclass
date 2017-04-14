# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: epunt-cxx.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: A function to punt C++ compiler checks from autoconf
# @DESCRIPTION:
# Support for punting C++ compiler checks from autoconf (based
# on ELT-patches).

if [[ -z ${_EPUNT_CXX_ECLASS} ]]; then

# eutils for eqawarn
inherit eutils

DEPEND=">=app-portage/elt-patches-20170317"

# @FUNCTION: epunt_cxx
# @USAGE: [dir to scan]
# @DESCRIPTION:
# Many configure scripts wrongly bail when a C++ compiler could not be
# detected.  If dir is not specified, then it defaults to ${S}.
#
# https://bugs.gentoo.org/73450
epunt_cxx() {
	local dir=$1
	[[ -z ${dir} ]] && dir=${S}
	ebegin "Removing useless C++ checks"
	local f p any_found
	while IFS= read -r -d '' f; do
		for p in "${EPREFIX}/usr/share/elt-patches"/nocxx/*.patch ; do
			if patch --no-backup-if-mismatch -p1 "${f}" "${p}" >/dev/null ; then
				any_found=1
				break
			fi
		done
	done < <(find "${dir}" -name configure -print0)

	if [[ -z ${any_found} ]]; then
		eqawarn "epunt_cxx called unnecessarily (no C++ checks to punt)."
	fi
	eend 0
}

_EPUNT_CXX_ECLASS=1
fi #_EPUNT_CXX_ECLASS
