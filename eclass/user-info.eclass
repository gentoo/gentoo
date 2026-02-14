# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: user-info.eclass
# @MAINTAINER:
# base-system@gentoo.org (Linux)
# Michał Górny <mgorny@gentoo.org> (NetBSD)
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Read-only access to user and group information

if [[ -z ${_USER_INFO_ECLASS} ]]; then
_USER_INFO_ECLASS=1

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: egetent
# @USAGE: <database> <key>
# @DESCRIPTION:
# Small wrapper for getent (Linux), nidump (< Mac OS X 10.5),
# dscl (Mac OS X 10.5), and pw (FreeBSD) used in enewuser()/enewgroup().
#
# Supported databases: group passwd
# Warning: This function can be used only in pkg_* phases when ROOT is valid.
egetent() {
	local db=$1 key=$2

	[[ $# -ge 3 ]] && die "usage: egetent <database> <key>"

	case ${db} in
	passwd|group) ;;
	*) die "sorry, database '${db}' not yet supported; file a bug" ;;
	esac

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		case ${db} in
		passwd) db="user" ;;
		*) ;;
		esac

		# lookup by uid/gid
		local opts
		if [[ ${key} == [[:digit:]]* ]] ; then
			[[ ${db} == "user" ]] && opts=( -u ) || opts=( -g )
		fi

		# Handle different ROOT
		[[ -n ${ROOT} ]] && opts+=( -R "${ROOT}" )

		pw show ${db} ${opts} "${key}" -q
		;;
	*-openbsd*)
		grep "${key}:\*:" "${EROOT}/etc/${db}"
		;;
	*)
		# getent does not support -R option, if we are working on a different
		# ROOT than /, fallback to grep technique.
		if [[ -z ${ROOT} ]]; then
			# ignore nscd output if we're not running as root
			type -p nscd >/dev/null && nscd -i "${db}" 2>/dev/null
			getent "${db}" "${key}"
		else
			if [[ ${key} =~ ^[[:digit:]]+$ ]]; then
				grep -E "^([^:]*:){2}${key}:" "${ROOT}/etc/${db}"
			else
				grep "^${key}:" "${ROOT}/etc/${db}"
			fi
		fi
		;;
	esac
}

# @FUNCTION: egetusername
# @USAGE: <uid>
# @DESCRIPTION:
# Gets the username for given UID.
egetusername() {
	[[ $# -eq 1 ]] || die "usage: egetusername <uid>"

	egetent passwd "$1" | cut -d: -f1
}

# @FUNCTION: egetgroupname
# @USAGE: <gid>
# @DESCRIPTION:
# Gets the group name for given GID.
egetgroupname() {
	[[ $# -eq 1 ]] || die "usage: egetgroupname <gid>"

	egetent group "$1" | cut -d: -f1
}

# @FUNCTION: egethome
# @USAGE: <user>
# @DESCRIPTION:
# Gets the home directory for the specified user.
egethome() {
	local pos

	[[ $# -eq 1 ]] || die "usage: egethome <user>"

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pos=9
		;;
	*)	# Linux, NetBSD, OpenBSD, etc...
		pos=6
		;;
	esac

	egetent passwd "$1" | cut -d: -f${pos}
}

# @FUNCTION: egetshell
# @USAGE: <user>
# @DESCRIPTION:
# Gets the shell for the specified user.
egetshell() {
	local pos

	[[ $# -eq 1 ]] || die "usage: egetshell <user>"

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pos=10
		;;
	*)	# Linux, NetBSD, OpenBSD, etc...
		pos=7
		;;
	esac

	egetent passwd "$1" | cut -d: -f${pos}
}

# @FUNCTION: egetcomment
# @USAGE: <user>
# @DESCRIPTION:
# Gets the comment field for the specified user.
egetcomment() {
	local pos

	[[ $# -eq 1 ]] || die "usage: egetcomment <user>"

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pos=8
		;;
	*)	# Linux, NetBSD, OpenBSD, etc...
		pos=5
		;;
	esac

	egetent passwd "$1" | cut -d: -f${pos}
}

# @FUNCTION: egetgroups
# @USAGE: <user>
# @DESCRIPTION:
# Gets all the groups user belongs to.  The primary group is returned
# first, then all supplementary groups.  Groups are ','-separated.
egetgroups() {
	[[ $# -eq 1 ]] || die "usage: egetgroups <user>"

	local egroups_arr

	if [[ -n "${ROOT}" ]]; then
		local pgid=$(egetent passwd "$1" | cut -d: -f4)
		local pgroup=$(egetent group "${pgid}" | cut -d: -f1)
		local sgroups=( $(grep -E ":([^:]*,)?$1(,[^:]*)?$" "${ROOT}/etc/group" | cut -d: -f1) )
		egroups_arr=( "${pgroup}" )
		local sg
		for sg in "${sgroups[@]}"; do
			if [[ ${sg} != ${pgroup} ]]; then
				egroups_arr+=( "${sg}" )
			fi
		done
	else
		read -r -a egroups_arr < <(id -G -n "$1")
	fi

	local g groups=${egroups_arr[0]}
	# sort supplementary groups to make comparison possible
	while read -r g; do
		[[ -n ${g} ]] && groups+=",${g}"
	done < <(printf '%s\n' "${egroups_arr[@]:1}" | sort)
	echo "${groups}"
}

fi
