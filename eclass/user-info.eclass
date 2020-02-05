# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: user-info.eclass
# @MAINTAINER:
# base-system@gentoo.org (Linux)
# Michał Górny <mgorny@gentoo.org> (NetBSD)
# @BLURB: Read-only access to user and group information

if [[ -z ${_USER_INFO_ECLASS} ]]; then
_USER_INFO_ECLASS=1

# @FUNCTION: egetent
# @USAGE: <database> <key>
# @DESCRIPTION:
# Small wrapper for getent (Linux), nidump (< Mac OS X 10.5),
# dscl (Mac OS X 10.5), and pw (FreeBSD) used in enewuser()/enewgroup().
#
# Supported databases: group passwd
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
			[[ ${db} == "user" ]] && opts="-u" || opts="-g"
		fi

		pw show ${db} ${opts} "${key}" -q
		;;
	*-openbsd*)
		grep "${key}:\*:" /etc/${db}
		;;
	*)
		# ignore nscd output if we're not running as root
		type -p nscd >/dev/null && nscd -i "${db}" 2>/dev/null
		getent "${db}" "${key}"
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

	[[ $# -eq 1 ]] || die "usage: egetshell <user>"

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
	read -r -a egroups_arr < <(id -G -n "$1")

	local g groups=${egroups_arr[0]}
	# sort supplementary groups to make comparison possible
	while read -r g; do
		[[ -n ${g} ]] && groups+=",${g}"
	done < <(printf '%s\n' "${egroups_arr[@]:1}" | sort)
	echo "${groups}"
}

fi
