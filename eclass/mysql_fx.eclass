# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Author: Francesco Riosa (Retired) <vivo@gentoo.org>
# Maintainer:
#	- MySQL Team <mysql-bugs@gentoo.org>
#	- Luca Longinotti <chtekk@gentoo.org>

inherit multilib

#
# Helper function, version (integer) may have sections separated by dots
# for readability.
#
stripdots() {
	local dotver=${1:-"0"}
	local v=""
	local ret=0
	if [[ "${dotver/./}" != "${dotver}" ]] ; then
		# dotted version number
		for i in 1000000 10000 100 1 ; do
			v=${dotver%%\.*}
			# remove leading zeroes
			while [[ ${#v} -gt 1 ]] && [[ ${v:0:1} == "0" ]] ; do v=${v#0} ; done
			# increment integer version number
			ret=$(( ${v} * ${i} + ${ret} ))
			if [[ "${dotver}" == "${dotver/\.}" ]] ; then
				dotver=0
			else
				dotver=${dotver#*\.}
			fi
		done
		echo "${ret}"
	else
		# already an integer
		v=${dotver}
		while [[ ${#v} -gt 1 ]] && [[ ${v:0:1} == "0" ]] ; do v=${v#0} ; done
		echo "${v}"
	fi
}

#
# Check if a version number falls inside a given range.
# The range includes the extremes and must be specified as
# "low_version to high_version" i.e. "4.1.2 to 5.1.99.99".
# Returns true if inside the range.
#
mysql_check_version_range() {
	local lbound="${1%% to *}" ; lbound=$(stripdots "${lbound}")
	local rbound="${1#* to }"  ; rbound=$(stripdots "${rbound}")
	local my_ver="${2:-"${MYSQL_VERSION_ID}"}"
	[[ ${lbound} -le ${my_ver} ]] && [[ ${my_ver} -le ${rbound} ]] && return 0
	return 1
}

#
# True if at least one applicable range is found for the patch.
#
_mysql_test_patch_ver_pn() {
	local allelements=", version, package name"
	# So that it fails the directory test if none of them exist
	local filesdir="/dev/null"
	for d in "${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}" \
		"${WORKDIR}/mysql-extras" ; do
		if [ -d "${d}" ]; then
			filesdir="${d}"
			break
		fi
	done

	[[ -d "${filesdir}" ]] || die "Source dir must be a directory"
	local flags=$1 pname=$2
	if [[ $(( $flags & $(( 1 + 4 + 16 )) )) -eq 21 ]] ; then
		einfo "using '${pname}'"
		ln -sf "${filesdir}/${pname}" "${EPATCH_SOURCE}" || die "Couldn't move ${pname}"
		return 0
	fi

	[[ $(( $flags & $(( 2 + 4 )) )) -gt 0 ]] \
	&& allelements="${allelements//", version"}"

	[[ $(( $flags & $(( 8 + 16 )) )) -gt 0 ]] \
	&& allelements="${allelements//", package name"}"

	[[ -n "${allelements}" ]] && [[ "${flags}" -gt 0 ]] \
	&& ewarn "QA notice: ${allelements} missing in ${pname} patch"

	return 1
}

#
# Parse a "index_file" looking for patches to apply to the
# current MySQL version.
# If the patch applies, print its description.
#
mysql_mv_patches() {
	# So that it fails the directory test if none of them exist
	local filesdir="/dev/null"
	if [[ -z "${1}" ]]; then
		for d in "${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}" \
			"${WORKDIR}/mysql-extras" ; do
			if [ -d "${d}" ]; then
				filesdir="${d}"
				break
			fi
		done
		[[ -d "${filesdir}" ]] || die "No patches directory found!"
	fi

	for i in "$1" "${filesdir}/0000_index.txt" "${filesdir}/000_index.txt" ; do
		if [ -n "$i" -a -f "$i" ]; then
			local index_file="$i"
			break
		fi
	done

	local my_ver="${2:-"${MYSQL_VERSION_ID}"}"
	local my_test_fx=${3:-"_mysql_test_patch_ver_pn"}
	_mysql_mv_patches "${index_file}" "${my_ver}" "${my_test_fx}"
}

_mysql_mv_patches() {
	local index_file="${1}"
	local my_ver="${2}"
	local my_test_fx="${3}"
	local dsc ndsc=0 i
	dsc=( )

	# Values for flags are (2^x):
	#  1 - one patch found
	#  2 - at least one version range is wrong
	#  4 - at least one version range is ok
	#  8 - at least one ${PN} did not match
	#  16 - at least one ${PN} has been matched
	local flags=0 pname=""
	while read row ; do
		case "${row}" in
			@patch\ *)
				[[ -n "${pname}" ]] \
				&& ${my_test_fx} ${flags} "${pname}" \
				&& for (( i=0 ; $i < $ndsc ; i++ )) ; do einfo ">    ${dsc[$i]}" ; done
				flags=1 ; ndsc=0 ; dsc=( )
				pname=${row#"@patch "}
				;;
			@ver\ *)
				if mysql_check_version_range "${row#"@ver "}" "${my_ver}" ; then
					flags=$(( ${flags} | 4 ))
				else
					flags=$(( ${flags} | 2 ))
				fi
				;;
			@pn\ *)
				if [[ ${row#"@pn "} == "${PN}" ]] ; then
					flags=$(( ${flags} | 16 ))
				else
					flags=$(( ${flags} | 8 ))
				fi
				;;
			# @use\ *) ;;
			@@\ *)
				dsc[$ndsc]="${row#"@@ "}"
				(( ++ndsc ))
				;;
		esac
	done < "${index_file}"

	${my_test_fx} ${flags} "${pname}" \
	&& for (( i=0 ; $i < $ndsc ; i++ )) ; do einfo ">    ${dsc[$i]}" ; done
}

#
# Is $2 (defaults to $MYSQL_VERSION_ID) at least version $1?
# (nice) idea from versionator.eclass
#
mysql_version_is_at_least() {
	local want_s=$(stripdots "$1") have_s=$(stripdots "${2:-${MYSQL_VERSION_ID}}")
	[[ -z "${want_s}" ]] && die "mysql_version_is_at_least missing value to check"
	[[ ${want_s} -le ${have_s} ]] && return 0 || return 1
}

#
# To be called on the live filesystem, reassigning symlinks of each MySQL
# library to the best version available.
#
mysql_lib_symlinks() {

	local d dirlist maxdots libname libnameln libsuffix reldir
	libsuffix=$(get_libname)

	einfo "libsuffix = ${libsuffix}"
	einfo "Updating MySQL libraries symlinks"

	reldir="${1}"
	pushd "${reldir}/usr/$(get_libdir)" &> /dev/null

	# dirlist must contain the less significative directory left
	dirlist="mysql"

	# waste some time in removing and recreating symlinks
	for d in $dirlist ; do
		for libname in $( find "${d}" -mindepth 1 -maxdepth 1 -name "*${libsuffix}*" -and -not -type "l" 2>/dev/null ) ; do
			# maxdot is a limit versus infinite loop
			maxdots=0
			libnameln=${libname##*/}
			# loop in version of the library to link it, similar to how
			# libtool works
			if [[ ${CHOST} == *-darwin* ]] ; then
				# macho: libname.x.y.z.dylib
				local libbasename=${libnameln%%.*}       # libname
				local libver=${libnameln#${libbasename}} # .x.y.z.dylib
				libver=${libver%${libsuffix}}            # .x.y.z
				while [[ -n ${libver} ]] && [[ ${maxdots} -lt 6 ]] ; do
					libnameln="${libbasename}${libver}${libsuffix}"
					rm -f "${libnameln}"
					ln -s "${libname}" "${libnameln}"
					(( ++maxdots ))
					libver=${libver%.*}
				done
				libnameln="${libbasename}${libsuffix}"
				rm -f "${libnameln}"
				ln -s "${libname}" "${libnameln}"
			else
				# elf: libname.so.x.y.z
				while [[ ${libnameln:0-3} != '${libsuffix}' ]] && [[ ${maxdots} -lt 6 ]] ; do
					rm -f "${libnameln}"
					ln -s "${libname}" "${libnameln}"
					(( ++maxdots ))
					libnameln="${libnameln%.*}"
				done
				rm -f "${libnameln}"
				ln -s "${libname}" "${libnameln}"
			fi
		done
	done

	popd &> /dev/null
}

# @FUNCTION: mysql_init_vars
# @DESCRIPTION:
# void mysql_init_vars()
# Initialize global variables
# 2005-11-19 <vivo@gentoo.org>
mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="${EPREFIX}/usr/share/mysql"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="${EPREFIX}/etc/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="${EPREFIX}/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="${EPREFIX}/var/log/mysql"}
	MY_INCLUDEDIR=${MY_INCLUDEDIR="${EPREFIX}/usr/include/mysql"}
	MY_LIBDIR=${MY_LIBDIR="${EPREFIX}/usr/$(get_libdir)/mysql"}

	if [[ -z "${MY_DATADIR}" ]] ; then
		MY_DATADIR=""
		if [[ -f "${MY_SYSCONFDIR}/my.cnf" ]] ; then
			MY_DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`
			if [[ -z "${MY_DATADIR}" ]] ; then
				MY_DATADIR=`grep ^datadir "${MY_SYSCONFDIR}/my.cnf" \
				| sed -e 's/.*=\s*//' \
				| tail -n1`
			fi
		fi
		if [[ -z "${MY_DATADIR}" ]] ; then
			MY_DATADIR="${MY_LOCALSTATEDIR}"
			einfo "Using default MY_DATADIR"
		fi
		elog "MySQL MY_DATADIR is ${MY_DATADIR}"

		if [[ -z "${PREVIOUS_DATADIR}" ]] ; then
			if [[ -e "${MY_DATADIR}" ]] ; then
				# If you get this and you're wondering about it, see bug #207636
				elog "MySQL datadir found in ${MY_DATADIR}"
				elog "A new one will not be created."
				PREVIOUS_DATADIR="yes"
			else
				PREVIOUS_DATADIR="no"
			fi
			export PREVIOUS_DATADIR
		fi
	else
		if [[ ${EBUILD_PHASE} == "config" ]]; then
			local new_MY_DATADIR
			new_MY_DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`

			if [[ ( -n "${new_MY_DATADIR}" ) && ( "${new_MY_DATADIR}" != "${MY_DATADIR}" ) ]]; then
				ewarn "MySQL MY_DATADIR has changed"
				ewarn "from ${MY_DATADIR}"
				ewarn "to ${new_MY_DATADIR}"
				MY_DATADIR="${new_MY_DATADIR}"
			fi
		fi
	fi

	if [ "${MY_SOURCEDIR:-unset}" == "unset" ]; then
		MY_SOURCEDIR=${SERVER_URI##*/}
		MY_SOURCEDIR=${MY_SOURCEDIR%.tar*}
	fi

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LIBDIR MY_LOCALSTATEDIR MY_LOGDIR
	export MY_INCLUDEDIR MY_DATADIR MY_SOURCEDIR
}
