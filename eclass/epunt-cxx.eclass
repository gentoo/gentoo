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

# TODO: replace this with 'inherit eutils' once eutils stops inheriting
# us
if ! declare -F eqawarn >/dev/null ; then
	eqawarn() {
		has qa ${PORTAGE_ELOG_CLASSES} && ewarn "$@"
		:
	}
fi

# If an overlay has eclass overrides, but doesn't actually override the
# libtool.eclass, we'll have ECLASSDIR pointing to the active overlay's
# eclass/ dir, but libtool.eclass is still in the main Gentoo tree.  So
# add a check to locate the ELT-patches/ regardless of what's going on.
# Note: Duplicated in libtool.eclass.
_EUTILS_ECLASSDIR_LOCAL=${BASH_SOURCE[0]%/*}
eutils_elt_patch_dir() {
	local d="${ECLASSDIR}/ELT-patches"
	if [[ ! -d ${d} ]] ; then
		d="${_EUTILS_ECLASSDIR_LOCAL}/ELT-patches"
	fi
	echo "${d}"
}

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
		for p in "$(eutils_elt_patch_dir)"/nocxx/*.patch ; do
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
