# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: user.eclass
# @MAINTAINER:
# base-system@gentoo.org (Linux)
# Michał Górny <mgorny@gentoo.org> (NetBSD)
# @BLURB: user management in ebuilds
# @DESCRIPTION:
# The user eclass contains a suite of functions that allow ebuilds
# to quickly make sure users in the installed system are sane.

if [[ -z ${_USER_ECLASS} ]]; then
_USER_ECLASS=1

# @FUNCTION: _assert_pkg_ebuild_phase
# @INTERNAL
# @USAGE: <calling func name>
_assert_pkg_ebuild_phase() {
	case ${EBUILD_PHASE} in
	setup|preinst|postinst|prerm|postrm) ;;
	*)
		eerror "'$1()' called from '${EBUILD_PHASE}' phase which is not OK:"
		eerror "You may only call from pkg_{setup,{pre,post}{inst,rm}} functions."
		eerror "Package fails at QA and at life.  Please file a bug."
		die "Bad package!  $1 is only for use in some pkg_* functions!"
	esac
}

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

# @FUNCTION: user_get_nologin
# @INTERNAL
# @DESCRIPTION:
# Find an appropriate 'nologin' shell for the platform, and output
# its path.
user_get_nologin() {
	local eshell

	for eshell in /sbin/nologin /usr/sbin/nologin /bin/false /usr/bin/false /dev/null ; do
		[[ -x ${ROOT}${eshell} ]] && break
	done

	if [[ ${eshell} == "/dev/null" ]] ; then
		ewarn "Unable to identify the shell to use, proceeding with userland default."
		case ${USERLAND} in
			GNU)    eshell="/bin/false" ;;
			BSD)    eshell="/sbin/nologin" ;;
			Darwin) eshell="/usr/sbin/nologin" ;;
			*) die "Unable to identify the default shell for userland ${USERLAND}"
		esac
	fi

	echo "${eshell}"
}

# @FUNCTION: enewuser
# @USAGE: <user> [-F] [-M] [uid] [shell] [homedir] [groups]
# @DESCRIPTION:
# Same as enewgroup, you are not required to understand how to properly add
# a user to the system.  The only required parameter is the username.
# Default uid is (pass -1 for this) next available, default shell is
# /bin/false, default homedir is /dev/null, and there are no default groups.
#
# If -F is passed, enewuser will always enforce specified UID and fail if it
# can not be assigned.
# If -M is passed, enewuser does not create the home directory if it does not
# exist.
enewuser() {
	if [[ ${EUID} != 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi
	_assert_pkg_ebuild_phase ${FUNCNAME}

	local create_home=1 force_uid=
	while [[ $1 == -* ]]; do
		case $1 in
			-F) force_uid=1;;
			-M) create_home=;;
			*) die "${FUNCNAME}: invalid option ${1}";;
		esac
		shift
	done

	# get the username
	local euser=$1; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified !"
		die "Cannot call enewuser without a username"
	fi

	# lets see if the username already exists
	if [[ -n $(egetent passwd "${euser}") ]] ; then
		return 0
	fi
	einfo "Adding user '${euser}' to your system ..."

	# options to pass to useradd
	local opts=()

	# handle uid
	local euid=$1; shift
	if [[ -n ${euid} && ${euid} != -1 ]] ; then
		if [[ ${euid} -gt 0 ]] ; then
			if [[ -n $(egetent passwd ${euid}) ]] ; then
				[[ -n ${force_uid} ]] && die "${FUNCNAME}: UID ${euid} already taken"
				euid="next"
			fi
		else
			eerror "Userid given but is not greater than 0 !"
			die "${euid} is not a valid UID"
		fi
	else
		[[ -n ${force_uid} ]] && die "${FUNCNAME}: -F with uid==-1 makes no sense"
		euid="next"
	fi
	if [[ ${euid} == "next" ]] ; then
		for ((euid = 999; euid >= 101; euid--)); do
			[[ -z $(egetent passwd ${euid}) ]] && break
		done
		[[ ${euid} -ge 101 ]] || die "${FUNCNAME}: no free UID found"
	fi
	opts+=( -u ${euid} )
	einfo " - Userid: ${euid}"

	# handle shell
	local eshell=$1; shift
	if [[ ! -z ${eshell} ]] && [[ ${eshell} != "-1" ]] ; then
		if [[ ! -e ${ROOT}${eshell} ]] ; then
			eerror "A shell was specified but it does not exist !"
			die "${eshell} does not exist in ${ROOT}"
		fi
		if [[ ${eshell} == */false || ${eshell} == */nologin ]] ; then
			eerror "Do not specify ${eshell} yourself, use -1"
			die "Pass '-1' as the shell parameter"
		fi
	else
		eshell=$(user_get_nologin)
	fi
	einfo " - Shell: ${eshell}"
	opts+=( -s "${eshell}" )

	# handle homedir
	local ehome=$1; shift
	if [[ -z ${ehome} ]] || [[ ${ehome} == "-1" ]] ; then
		ehome="/dev/null"
	fi
	einfo " - Home: ${ehome}"
	opts+=( -d "${ehome}" )

	# handle groups
	local egroups=$1; shift
	local g egroups_arr
	IFS="," read -r -a egroups_arr <<<"${egroups}"
	if [[ ${#egroups_arr[@]} -gt 0 ]] ; then
		local defgroup exgroups
		for g in "${egroups_arr[@]}" ; do
			if [[ -z $(egetent group "${g}") ]] ; then
				eerror "You must add group ${g} to the system first"
				die "${g} is not a valid GID"
			fi
			if [[ -z ${defgroup} ]] ; then
				defgroup=${g}
			else
				exgroups+=",${g}"
			fi
		done
		opts+=( -g "${defgroup}" )
		if [[ ! -z ${exgroups} ]] ; then
			opts+=( -G "${exgroups:1}" )
		fi
	fi
	einfo " - Groups: ${egroups:-(none)}"

	# handle extra args
	if [[ $# -gt 0 ]] ; then
		die "extra arguments no longer supported; please file a bug"
	else
		local comment="added by portage for ${PN}"
		opts+=( -c "${comment}" )
		einfo " - GECOS: ${comment}"
	fi

	# add the user
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw useradd "${euser}" "${opts[@]}" || die
		;;

	*-netbsd*)
		useradd "${opts[@]}" "${euser}" || die
		;;

	*-openbsd*)
		# all ops the same, except the -g vs -g/-G ...
		useradd -u ${euid} -s "${eshell}" \
			-d "${ehome}" -g "${egroups}" "${euser}" || die
		;;

	*)
		useradd -M -N -r "${opts[@]}" "${euser}" || die
		;;
	esac

	if [[ -n ${create_home} && ! -e ${ROOT}/${ehome} ]] ; then
		einfo " - Creating ${ehome} in ${ROOT}"
		mkdir -p "${ROOT}/${ehome}"
		chown "${euser}" "${ROOT}/${ehome}"
		chmod 755 "${ROOT}/${ehome}"
	fi
}

# @FUNCTION: enewgroup
# @USAGE: <group> [gid]
# @DESCRIPTION:
# This function does not require you to understand how to properly add a
# group to the system.  Just give it a group name to add and enewgroup will
# do the rest.  You may specify the gid for the group or allow the group to
# allocate the next available one.
#
# If -F is passed, enewgroup will always enforce specified GID and fail if it
# can not be assigned.
enewgroup() {
	if [[ ${EUID} != 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi
	_assert_pkg_ebuild_phase ${FUNCNAME}

	local force_gid=
	while [[ $1 == -* ]]; do
		case $1 in
			-F) force_gid=1;;
			*) die "${FUNCNAME}: invalid option ${1}";;
		esac
		shift
	done

	# get the group
	local egroup=$1; shift
	if [[ -z ${egroup} ]] ; then
		eerror "No group specified !"
		die "Cannot call enewgroup without a group"
	fi

	# see if group already exists
	if [[ -n $(egetent group "${egroup}") ]] ; then
		return 0
	fi
	einfo "Adding group '${egroup}' to your system ..."

	# handle gid
	local egid=$1; shift
	if [[ ! -z ${egid} ]] ; then
		if [[ ${egid} -gt 0 ]] ; then
			if [[ -n $(egetent group ${egid}) ]] ; then
				[[ -n ${force_gid} ]] && die "${FUNCNAME}: GID ${egid} already taken"
				egid="next available; requested gid taken"
			fi
		else
			eerror "Groupid given but is not greater than 0 !"
			die "${egid} is not a valid GID"
		fi
	else
		[[ -n ${force_gid} ]] && die "${FUNCNAME}: -F with gid==-1 makes no sense"
		egid="next available"
	fi
	einfo " - Groupid: ${egid}"

	# handle extra
	if [[ $# -gt 0 ]] ; then
		die "extra arguments no longer supported; please file a bug"
	fi

	# Some targets need to find the next available GID manually
	_enewgroup_next_gid() {
		if [[ ${egid} == *[!0-9]* ]] ; then
			# Non numeric
			for ((egid = 999; egid >= 101; egid--)) ; do
				[[ -z $(egetent group ${egid}) ]] && break
			done
			[[ ${egid} -ge 101 ]] || die "${FUNCNAME}: no free GID found"
		fi
	}

	# add the group
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		_enewgroup_next_gid
		pw groupadd "${egroup}" -g ${egid} || die
		;;

	*-netbsd*)
		_enewgroup_next_gid
		groupadd -g ${egid} "${egroup}" || die
		;;

	*)
		local opts
		if [[ ${egid} == *[!0-9]* ]] ; then
			# Non numeric; let groupadd figure out a GID for us
			opts=""
		else
			opts="-g ${egid}"
		fi
		# We specify -r so that we get a GID in the system range from login.defs
		groupadd -r ${opts} "${egroup}" || die
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

# @FUNCTION: esethome
# @USAGE: <user> <homedir>
# @DESCRIPTION:
# Update the home directory in a platform-agnostic way.
# Required parameters is the username and the new home directory.
# Specify -1 if you want to set home to the enewuser default
# of /dev/null.
# If the new home directory does not exist, it is created.
# Any previously existing home directory is NOT moved.
esethome() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

	# get the username
	local euser=$1; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified !"
		die "Cannot call esethome without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set home dir -- skipping."
		return 1
	fi

	# handle homedir
	local ehome=$1; shift
	if [[ -z ${ehome} ]] ; then
		eerror "No home directory specified !"
		die "Cannot call esethome without a home directory or '-1'"
	fi

	if [[ ${ehome} == "-1" ]] ; then
		ehome="/dev/null"
	fi

	# exit with no message if home dir is up to date
	if [[ $(egethome "${euser}") == ${ehome} ]]; then
		return 0
	fi

	einfo "Updating home for user '${euser}' ..."
	einfo " - Home: ${ehome}"

	# ensure home directory exists, otherwise update will fail
	if [[ ! -e ${ROOT}/${ehome} ]] ; then
		einfo " - Creating ${ehome} in ${ROOT}"
		mkdir -p "${ROOT}/${ehome}"
		chown "${euser}" "${ROOT}/${ehome}"
		chmod 755 "${ROOT}/${ehome}"
	fi

	# update the home directory
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${euser}" -d "${ehome}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update home"
		eerror "There was an error when attempting to update the home directory for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -d \"${ehome}\""
		;;

	*)
		usermod -d "${ehome}" "${euser}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update home"
		eerror "There was an error when attempting to update the home directory for ${euser}"
		eerror "Please update it manually on your system (as root):"
		eerror "\t usermod -d \"${ehome}\" \"${euser}\""
		;;
	esac
}

# @FUNCTION: esetshell
# @USAGE: <user> <shell>
# @DESCRIPTION:
# Update the shell in a platform-agnostic way.
# Required parameters is the username and the new shell.
# Specify -1 if you want to set shell to platform-specific nologin.
esetshell() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

	# get the username
	local euser=$1; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified !"
		die "Cannot call esetshell without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set shell -- skipping."
		return 1
	fi

	# handle shell
	local eshell=$1; shift
	if [[ -z ${eshell} ]] ; then
		eerror "No shell specified !"
		die "Cannot call esetshell without a shell or '-1'"
	fi

	if [[ ${eshell} == "-1" ]] ; then
		eshell=$(user_get_nologin)
	fi

	# exit with no message if shell is up to date
	if [[ $(egetshell "${euser}") == ${eshell} ]]; then
		return 0
	fi

	einfo "Updating shell for user '${euser}' ..."
	einfo " - Shell: ${eshell}"

	# update the shell
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${euser}" -s "${eshell}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
		eerror "There was an error when attempting to update the shell for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -s \"${eshell}\""
		;;

	*)
		usermod -s "${eshell}" "${euser}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
		eerror "There was an error when attempting to update the shell for ${euser}"
		eerror "Please update it manually on your system (as root):"
		eerror "\t usermod -s \"${eshell}\" \"${euser}\""
		;;
	esac
}

# @FUNCTION: esetcomment
# @USAGE: <user> <comment>
# @DESCRIPTION:
# Update the comment field in a platform-agnostic way.
# Required parameters is the username and the new comment.
esetcomment() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

	# get the username
	local euser=$1; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified !"
		die "Cannot call esetcomment without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set comment -- skipping."
		return 1
	fi

	# handle comment
	local ecomment=$1; shift
	if [[ -z ${ecomment} ]] ; then
		eerror "No comment specified !"
		die "Cannot call esetcomment without a comment"
	fi

	# exit with no message if comment is up to date
	if [[ $(egetcomment "${euser}") == ${ecomment} ]]; then
		return 0
	fi

	einfo "Updating comment for user '${euser}' ..."
	einfo " - Comment: ${ecomment}"

	# update the comment
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${euser}" -c "${ecomment}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update comment"
		eerror "There was an error when attempting to update the comment for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -c \"${ecomment}\""
		;;

	*)
		usermod -c "${ecomment}" "${euser}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update comment"
		eerror "There was an error when attempting to update the comment for ${euser}"
		eerror "Please update it manually on your system (as root):"
		eerror "\t usermod -c \"${ecomment}\" \"${euser}\""
		;;
	esac
}

# @FUNCTION: esetgroups
# @USAGE: <user> <groups>
# @DESCRIPTION:
# Update the group field in a platform-agnostic way.
# Required parameters is the username and the new list of groups,
# primary group first.
esetgroups() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

	[[ ${#} -eq 2 ]] || die "Usage: ${FUNCNAME} <user> <groups>"

	# get the username
	local euser=$1; shift

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set group -- skipping."
		return 1
	fi

	# handle group
	local egroups=$1; shift

	local g egroups_arr=()
	IFS="," read -r -a egroups_arr <<<"${egroups}"
	[[ ${#egroups_arr[@]} -gt 0 ]] || die "${FUNCNAME}: no groups specified"

	for g in "${egroups_arr[@]}" ; do
		if [[ -z $(egetent group "${g}") ]] ; then
			eerror "You must add group ${g} to the system first"
			die "${g} is not a valid GID"
		fi
	done

	local defgroup=${egroups_arr[0]} exgroups_arr=()
	# sort supplementary groups to make comparison possible
	readarray -t exgroups_arr < <(printf '%s\n' "${egroups_arr[@]:1}" | sort)
	local exgroups=${exgroups_arr[*]}
	exgroups=${exgroups// /,}
	egroups=${defgroup}${exgroups:+,${exgroups}}

	# exit with no message if group membership is up to date
	if [[ $(egetgroups "${euser}") == ${egroups} ]]; then
		return 0
	fi

	local opts=( -g "${defgroup}" -G "${exgroups}" )
	einfo "Updating groups for user '${euser}' ..."
	einfo " - Groups: ${egroups}"

	# update the group
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${euser}" "${opts[@]}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update groups"
		eerror "There was an error when attempting to update the groups for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" ${opts[*]}"
		;;

	*)
		usermod "${opts[@]}" "${euser}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update groups"
		eerror "There was an error when attempting to update the groups for ${euser}"
		eerror "Please update it manually on your system (as root):"
		eerror "\t usermod ${opts[*]} \"${euser}\""
		;;
	esac
}

fi
