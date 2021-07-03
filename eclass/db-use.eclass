# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: db-use.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Paul de Vrieze <pauldv@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: functions that aid the use of sys-libs/db
# @DESCRIPTION:
# This eclass provides helpful functions for depending on sys-libs/db.

case ${EAPI} in
	5|6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DB_USE_ECLASS} ]]; then
_DB_USE_ECLASS=1

# multilib is used for get_libname
[[ ${EAPI} == [56] ]] && inherit eapi7-ver
inherit multilib

# @FUNCTION: db_ver_to_slot
# @USAGE: <version>
# @DESCRIPTION:
# Convert a version to a db slot.
db_ver_to_slot() {
	[[ $# -eq 1 ]] || die "${FUNCNAME} needs one argument"

	# 5.0.x uses 5.0 as slot value, so this replacement will break it;
	# older sys-libs/db might have been using this but it's no longer
	# the case, so make it work for latest rather than older stuff.
	echo "$1"
}

# @FUNCTION: db_findver
# @USAGE: [atom]
# @DESCRIPTION:
# Output the best version that corresponds to the given atom.  If no atom is
# given, sys-libs/db is used by default.
db_findver() {
	[[ $# -le 1 ]] || die "${FUNCNAME} needs zero or one arguments"

	local pkg=$(best_version "${1:-sys-libs/db}")
	local ver=$(ver_cut 1-2 "${pkg#*db-}")
	[[ -d ${ESYSROOT:-${EPREFIX}}/usr/include/db$(db_ver_to_slot "${ver}") ]] || return 1
	echo "${ver}"
}

# @FUNCTION: db_includedir
# @USAGE: [version]...
# @DESCRIPTION:
# Output the include directory for berkeley db.  Without any arguments, it will
# give the best version available.  With a list of versions, it will output the
# include directory of the first version found.
db_includedir() {
	local ver
	for ver in "${@:-}"; do
		ver=$(db_findver ${ver:+"=sys-libs/db-${ver}*"}) &&
		ver=$(db_ver_to_slot "${ver}") &&
		[[ -d ${ESYSROOT:-${EPREFIX}}/usr/include/db${ver} ]] &&
		echo "${ESYSROOT:-${EPREFIX}}/usr/include/db${ver}" &&
		return
	done
	eerror "No suitable db version found"
	return 1
}


# @FUNCTION: db_libname
# @USAGE: [version]...
# @DESCRIPTION:
# Output the library name for berkeley db of the form "db-4.2".  Without any
# arguments, it will give the best version available.  With a list of versions,
# it will output the library name of the first version found.
db_libname() {
	local ver
	for ver in "${@:-}"; do
		ver=$(db_findver ${ver:+"=sys-libs/db-${ver}*"}) &&
		[[ -e ${ESYSROOT:-${EPREFIX}}/usr/$(get_libdir)/libdb-${ver}$(get_libname) ]] &&
		echo "db-${ver}" &&
		return
	done
	eerror "No suitable db version found"
	return 1
}

fi
