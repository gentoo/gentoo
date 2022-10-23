# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# @ECLASS: user.eclass
# @MAINTAINER:
# base-system@gentoo.org (Linux)
# Michał Górny <mgorny@gentoo.org> (NetBSD)
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: user management in ebuilds
# @DEPRECATED: acct-user/acct-group packages
# @DESCRIPTION:
# The user eclass contains a suite of functions that allow ebuilds
# to quickly make sure users in the installed system are sane.

case ${EAPI} in
	6|7) ;;
	8)
		if [[ ${CATEGORY} != acct-* ]]; then
			eerror "In EAPI ${EAPI}, packages must not inherit user.eclass"
			eerror "unless they are in the acct-user or acct-group category."
			eerror "Migrate your package to GLEP 81 user/group management,"
			eerror "or inherit user-info if you need only the query functions."
			die "Invalid \"inherit user\" in EAPI ${EAPI}"
		fi
		;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_USER_ECLASS} ]]; then
_USER_ECLASS=1

inherit user-info

# @FUNCTION: _user_assert_pkg_phase
# @INTERNAL
# @USAGE: <calling func name>
# @DESCRIPTION:
# Raises an alert if the phase is not suitable for user.eclass usage.
_user_assert_pkg_phase() {
	case ${EBUILD_PHASE} in
	setup|preinst|postinst|prerm|postrm) ;;
	*)
		eerror "'$1()' called from '${EBUILD_PHASE}' phase which is not OK:"
		eerror "You may only call from pkg_{setup,{pre,post}{inst,rm}} functions."
		eerror "Package has serious QA issues.  Please file a bug."
		die "Bad package!  ${1} is only for use in some pkg_* functions!"
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
	if [[ ${EUID} -ne 0 ]] ; then
		ewarn "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi
	_user_assert_pkg_phase ${FUNCNAME}

	local create_home=1 force_uid=
	while [[ ${1} == -* ]]; do
		case ${1} in
			-F) force_uid=1;;
			-M) create_home=;;
			*) die "${FUNCNAME}: invalid option ${1}";;
		esac
		shift
	done

	# get the username
	local euser=${1}; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified!"
		die "Cannot call enewuser without a username"
	fi

	# lets see if the username already exists
	if [[ -n $(egetent passwd "${euser}") ]] ; then
		return 0
	fi
	elog "Adding user '${euser}' to your system ..."

	# options to pass to useradd
	local opts=()

	# handle for ROOT != /
	[[ -n ${ROOT} ]] && opts+=( --prefix "${ROOT}" )

	# handle uid
	local euid=${1}; shift
	if [[ -n ${euid} && ${euid} != -1 ]] ; then
		if [[ ${euid} -ge 0 ]] ; then
			if [[ -n $(egetent passwd ${euid}) ]] ; then
				[[ -n ${force_uid} ]] && die "${FUNCNAME}: UID ${euid} already taken"
				euid="next"
			fi
		else
			eerror "Userid given but is not greater than or equal to 0!"
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
	elog " - Userid: ${euid}"

	# handle shell
	local eshell=${1}; shift
	if [[ ! -z ${eshell} ]] && [[ ${eshell} != "-1" ]] ; then
		if [[ ! -e ${ROOT}${eshell} ]] ; then
			eerror "A shell was specified but it does not exist!"
			die "${eshell} does not exist in ${ROOT}"
		fi
		if [[ ${eshell} == */false || ${eshell} == */nologin ]] ; then
			eerror "Do not specify ${eshell} yourself, use -1"
			die "Pass '-1' as the shell parameter"
		fi
	else
		eshell=$(user_get_nologin)
	fi
	elog " - Shell: ${eshell}"
	opts+=( -s "${eshell}" )

	# handle homedir
	local ehome=${1}; shift
	if [[ -z ${ehome} ]] || [[ ${ehome} == "-1" ]] ; then
		ehome="/dev/null"
	fi
	elog " - Home: ${ehome}"
	opts+=( -d "${ehome}" )

	# handle groups
	local egroups=${1}; shift
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
	elog " - Groups: ${egroups:-(none)}"

	# handle extra args
	if [[ $# -gt 0 ]] ; then
		die "extra arguments no longer supported; please file a bug"
	else
		local comment="added by portage for ${PN}"
		opts+=( -c "${comment}" )
		elog " - GECOS: ${comment}"
	fi

	# add the user
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw useradd "${euser}" "${opts[@]}" || die
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix option."
			ewarn "Please use: \"useradd ${opts[@]} ${euser}\" in a chroot"
		else
			useradd "${opts[@]}" "${euser}" || die
		fi
		;;

	*-openbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "OpenBSD's usermod does not support --prefix option."
			ewarn "Please use: \"useradd ${opts[@]} ${euser}\" in a chroot"
		else
			# all ops the same, except the -g vs -g/-G ...
			useradd -u ${euid} -s "${eshell}" \
				-d "${ehome}" -g "${egroups}" "${euser}" || die
		fi

		;;

	*)
		useradd -M -N -r "${opts[@]}" "${euser}" || die
		;;
	esac

	if [[ -n ${create_home} && ! -e ${ROOT}/${ehome} ]] ; then
		elog " - Creating ${ehome} in ${ROOT}"
		mkdir -p "${ROOT}/${ehome}"
		# Use UID if we are in another ROOT than /
		if [[ -n "${ROOT}" ]]; then
			euser=$(egetent passwd ${euser} | cut -d: -f3)
		fi
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
	if [[ ${EUID} -ne 0 ]] ; then
		ewarn "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi
	_user_assert_pkg_phase ${FUNCNAME}

	local force_gid=
	while [[ ${1} == -* ]]; do
		case ${1} in
			-F) force_gid=1;;
			*) die "${FUNCNAME}: invalid option ${1}";;
		esac
		shift
	done

	# get the group
	local egroup=${1}; shift
	if [[ -z ${egroup} ]] ; then
		eerror "No group specified!"
		die "Cannot call enewgroup without a group"
	fi

	# see if group already exists
	if [[ -n $(egetent group "${egroup}") ]] ; then
		return 0
	fi
	elog "Adding group '${egroup}' to your system ..."

	# handle gid
	local egid=${1}; shift
	if [[ -n ${egid} && ${egid} != -1 ]] ; then
		if [[ ${egid} -ge 0 ]] ; then
			if [[ -n $(egetent group ${egid}) ]] ; then
				[[ -n ${force_gid} ]] && die "${FUNCNAME}: GID ${egid} already taken"
				egid="next available; requested gid taken"
			fi
		else
			eerror "Groupid given but is not greater than or equal to 0!"
			die "${egid} is not a valid GID"
		fi
	else
		[[ -n ${force_gid} ]] && die "${FUNCNAME}: -F with gid==-1 makes no sense"
		egid="next available"
	fi
	elog " - Groupid: ${egid}"

	# handle different ROOT
	local opts
	[[ -n ${ROOT} ]] && opts=( --prefix "${ROOT}" )

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
		pw groupadd "${opts[@]}" "${egroup}" -g ${egid} || die
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix <dir> option."
			ewarn "Please use: \"groupadd -g ${egid} ${opts[@]} ${egroup}\" in a chroot"
		else
			_enewgroup_next_gid
			groupadd -g ${egid} "${opts[@]}" "${egroup}" || die
		fi
		;;

	*)
		if [[ ${egid} == *[!0-9]* ]] ; then
			# Non numeric; let groupadd figure out a GID for us
			#
			true # Do nothing but keep the previous comment.
		else
			opts+=( -g ${egid} )
		fi
		# We specify -r so that we get a GID in the system range from login.defs
		groupadd -r "${opts[@]}" "${egroup}" || die
		;;
	esac
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
	_user_assert_pkg_phase ${FUNCNAME}

	# get the username
	local euser=${1}; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified!"
		die "Cannot call esethome without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set home dir -- skipping."
		return 1
	fi

	# Handle different ROOT
	local opts
	[[ -n ${ROOT} ]] && opts=( --prefix "${ROOT}" )

	# handle homedir
	local ehome=${1}; shift
	if [[ -z ${ehome} ]] ; then
		eerror "No home directory specified!"
		die "Cannot call esethome without a home directory or '-1'"
	fi

	if [[ ${ehome} == "-1" ]] ; then
		ehome="/dev/null"
	fi

	# exit with no message if home dir is up to date
	if [[ $(egethome "${euser}") == ${ehome} ]]; then
		return 0
	fi

	elog "Updating home for user '${euser}' ..."
	elog " - Home: ${ehome}"

	# ensure home directory exists, otherwise update will fail
	if [[ ! -e ${ROOT}/${ehome} ]] ; then
		elog " - Creating ${ehome} in ${ROOT}"
		mkdir -p "${ROOT}/${ehome}"
		chown "${euser}" "${ROOT}/${ehome}"
		chmod 755 "${ROOT}/${ehome}"
	fi

	# update the home directory
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${opts[@]}" "${euser}" -d "${ehome}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update home"
		eerror "There was an error when attempting to update the home directory for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -d \"${ehome}\""
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix <dir> option."
			ewarn "Please use: \"usermod ${opts[@]} -d ${ehome} ${euser}\" in a chroot"
		else
			usermod "${opts[@]}" -d "${ehome}" "${euser}" && return 0
			[[ $? == 8 ]] && eerror "${euser} is in use, cannot update home"
			eerror "There was an error when attempting to update the home directory for ${euser}"
			eerror "Please update it manually on your system (as root):"
			eerror "\t usermod -d \"${ehome}\" \"${euser}\""
		fi
		;;

	*)
		usermod "${opts[@]}" -d "${ehome}" "${euser}" && return 0
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
	_user_assert_pkg_phase ${FUNCNAME}

	# get the username
	local euser=${1}; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified!"
		die "Cannot call esetshell without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set shell -- skipping."
		return 1
	fi

	# Handle different ROOT
	local opts
	[[ -n ${ROOT} ]] && opts=( --prefix "${ROOT}" )

	# handle shell
	local eshell=${1}; shift
	if [[ -z ${eshell} ]] ; then
		eerror "No shell specified!"
		die "Cannot call esetshell without a shell or '-1'"
	fi

	if [[ ${eshell} == "-1" ]] ; then
		eshell=$(user_get_nologin)
	fi

	# exit with no message if shell is up to date
	if [[ $(egetshell "${euser}") == ${eshell} ]]; then
		return 0
	fi

	elog "Updating shell for user '${euser}' ..."
	elog " - Shell: ${eshell}"

	# update the shell
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${opts[@]}" "${euser}" -s "${eshell}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
		eerror "There was an error when attempting to update the shell for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -s \"${eshell}\""
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix <dir> option."
			ewarn "Please use: \"usermod ${opts[@]} -s ${eshell} ${euser}\" in a chroot"
		else
			usermod "${opts[@]}" -s "${eshell}" "${euser}" && return 0
			[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
			eerror "There was an error when attempting to update the shell for ${euser}"
			eerror "Please update it manually on your system (as root):"
			eerror "\t usermod -s \"${eshell}\" \"${euser}\""
		fi
		;;

	*)
		usermod "${opts[@]}" -s "${eshell}" "${euser}" && return 0
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
	_user_assert_pkg_phase ${FUNCNAME}

	# get the username
	local euser=${1}; shift
	if [[ -z ${euser} ]] ; then
		eerror "No username specified!"
		die "Cannot call esetcomment without a username"
	fi

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set comment -- skipping."
		return 1
	fi

	# Handle different ROOT
	local opts
	[[ -n ${ROOT} ]] && opts=( --prefix "${ROOT}" )

	# handle comment
	local ecomment=${1}; shift
	if [[ -z ${ecomment} ]] ; then
		eerror "No comment specified!"
		die "Cannot call esetcomment without a comment"
	fi

	# exit with no message if comment is up to date
	if [[ $(egetcomment "${euser}") == ${ecomment} ]]; then
		return 0
	fi

	elog "Updating comment for user '${euser}' ..."
	elog " - Comment: ${ecomment}"

	# update the comment
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${opts[@]}" "${euser}" -c "${ecomment}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update comment"
		eerror "There was an error when attempting to update the comment for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" -c \"${ecomment}\""
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix <dir> option."
			ewarn "Please use: \"usermod ${opts[@]} -c ${ecomment} ${euser}\" in a chroot"
		else
			usermod "${opts[@]}" -c "${ecomment}" "${euser}" && return 0
			[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
			eerror "There was an error when attempting to update the shell for ${euser}"
			eerror "Please update it manually on your system (as root):"
			eerror "\t usermod -s \"${eshell}\" \"${euser}\""
		fi
		;;

	*)
		usermod "${opts[@]}" -c "${ecomment}" "${euser}" && return 0
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
	_user_assert_pkg_phase ${FUNCNAME}

	[[ ${#} -eq 2 ]] || die "Usage: ${FUNCNAME} <user> <groups>"

	# get the username
	local euser=${1}; shift

	# lets see if the username already exists
	if [[ -z $(egetent passwd "${euser}") ]] ; then
		ewarn "User does not exist, cannot set group -- skipping."
		return 1
	fi

	# handle group
	local egroups=${1}; shift

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
	elog "Updating groups for user '${euser}' ..."
	elog " - Groups: ${egroups}"

	# Handle different ROOT
	[[ -n ${ROOT} ]] && opts+=( --prefix "${ROOT}" )

	# update the group
	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw usermod "${euser}" "${opts[@]}" && return 0
		[[ $? == 8 ]] && eerror "${euser} is in use, cannot update groups"
		eerror "There was an error when attempting to update the groups for ${euser}"
		eerror "Please update it manually on your system:"
		eerror "\t pw usermod \"${euser}\" ${opts[*]}"
		;;

	*-netbsd*)
		if [[ -n "${ROOT}" ]]; then
			ewarn "NetBSD's usermod does not support --prefix <dir> option."
			ewarn "Please use: \"usermod ${opts[@]} ${euser}\" in a chroot"
		else
			usermod "${opts[@]}" "${euser}" && return 0
			[[ $? == 8 ]] && eerror "${euser} is in use, cannot update shell"
			eerror "There was an error when attempting to update the shell for ${euser}"
			eerror "Please update it manually on your system (as root):"
			eerror "\t usermod -s \"${eshell}\" \"${euser}\""
		fi
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
