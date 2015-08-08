# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: user.eclass
# @MAINTAINER:
# base-system@gentoo.org (Linux)
# Joe Jezak <josejx@gmail.com> (OS X)
# usata@gentoo.org (OS X)
# Aaron Walker <ka0ttic@gentoo.org> (FreeBSD)
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
	setup|preinst|postinst) ;;
	*)
		eerror "'$1()' called from '${EBUILD_PHASE}' phase which is not OK:"
		eerror "You may only call from pkg_{setup,preinst,postinst} functions."
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
	*-darwin[678])
		case ${key} in
		*[!0-9]*) # Non numeric
			nidump ${db} . | awk -F: "(\$1 ~ /^${key}\$/) {print;exit;}"
			;;
		*)	# Numeric
			nidump ${db} . | awk -F: "(\$3 == ${key}) {print;exit;}"
			;;
		esac
		;;
	*-darwin*)
		local mykey
		case ${db} in
		passwd) db="Users"  mykey="UniqueID" ;;
		group)  db="Groups" mykey="PrimaryGroupID" ;;
		esac

		case ${key} in
		*[!0-9]*) # Non numeric
			dscl . -read /${db}/${key} 2>/dev/null |grep RecordName
			;;
		*)	# Numeric
			dscl . -search /${db} ${mykey} ${key} 2>/dev/null
			;;
		esac
		;;
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
	*-netbsd*|*-openbsd*)
		grep "${key}:\*:" /etc/${db}
		;;
	*)
		# ignore output if nscd doesn't exist, or we're not running as root
		nscd -i "${db}" 2>/dev/null
		getent "${db}" "${key}"
		;;
	esac
}

# @FUNCTION: enewuser
# @USAGE: <user> [uid] [shell] [homedir] [groups]
# @DESCRIPTION:
# Same as enewgroup, you are not required to understand how to properly add
# a user to the system.  The only required parameter is the username.
# Default uid is (pass -1 for this) next available, default shell is
# /bin/false, default homedir is /dev/null, and there are no default groups.
enewuser() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

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
				euid="next"
			fi
		else
			eerror "Userid given but is not greater than 0 !"
			die "${euid} is not a valid UID"
		fi
	else
		euid="next"
	fi
	if [[ ${euid} == "next" ]] ; then
		for ((euid = 101; euid <= 999; euid++)); do
			[[ -z $(egetent passwd ${euid}) ]] && break
		done
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
		for eshell in /sbin/nologin /usr/sbin/nologin /bin/false /usr/bin/false /dev/null ; do
			[[ -x ${ROOT}${eshell} ]] && break
		done

		if [[ ${eshell} == "/dev/null" ]] ; then
			eerror "Unable to identify the shell to use, proceeding with userland default."
			case ${USERLAND} in
				GNU)    eshell="/bin/false" ;;
				BSD)    eshell="/sbin/nologin" ;;
				Darwin) eshell="/usr/sbin/nologin" ;;
				*) die "Unable to identify the default shell for userland ${USERLAND}"
			esac
		fi
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
	shift
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
	*-darwin*)
		### Make the user
		dscl . create "/users/${euser}" uid ${euid}
		dscl . create "/users/${euser}" shell "${eshell}"
		dscl . create "/users/${euser}" home "${ehome}"
		dscl . create "/users/${euser}" realname "added by portage for ${PN}"
		### Add the user to the groups specified
		for g in "${egroups_arr[@]}" ; do
			dscl . merge "/groups/${g}" users "${euser}"
		done
		;;

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
		useradd -r "${opts[@]}" "${euser}" || die
		;;
	esac

	if [[ ! -e ${ROOT}/${ehome} ]] ; then
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
enewgroup() {
	_assert_pkg_ebuild_phase ${FUNCNAME}

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
				egid="next available; requested gid taken"
			fi
		else
			eerror "Groupid given but is not greater than 0 !"
			die "${egid} is not a valid GID"
		fi
	else
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
			for ((egid = 101; egid <= 999; egid++)) ; do
				[[ -z $(egetent group ${egid}) ]] && break
			done
		fi
	}

	# add the group
	case ${CHOST} in
	*-darwin*)
		_enewgroup_next_gid
		dscl . create "/groups/${egroup}" gid ${egid}
		dscl . create "/groups/${egroup}" passwd '*'
		;;

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

# @FUNCTION: egethome
# @USAGE: <user>
# @DESCRIPTION:
# Gets the home directory for the specified user.
egethome() {
	local pos

	[[ $# -eq 1 ]] || die "usage: egethome <user>"

	case ${CHOST} in
	*-darwin*|*-freebsd*|*-dragonfly*)
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
	*-darwin*|*-freebsd*|*-dragonfly*)
		pos=10
		;;
	*)	# Linux, NetBSD, OpenBSD, etc...
		pos=7
		;;
	esac

	egetent passwd "$1" | cut -d: -f${pos}
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
	*-darwin*)
		dscl . change "/users/${euser}" home "${ehome}"
		;;

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

fi
