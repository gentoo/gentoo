# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: acct-user.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michael Orlitzky <mjo@gentoo.org>
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass used to create and maintain a single user entry
# @DESCRIPTION:
# This eclass represents and creates a single user entry.  The name
# of the user is derived from ${PN}, while (preferred) UID needs to
# be specified via ACCT_USER_ID.  Additional variables are provided
# to override the default home directory, shell and add group
# membership.  Packages needing the user in question should depend
# on the package providing it.
#
# The ebuild needs to call acct-user_add_deps after specifying
# ACCT_USER_GROUPS.
#
# Example:
# If your package needs user 'foo' belonging to same-named group, you
# create 'acct-user/foo' package and add an ebuild with the following
# contents:
#
# @CODE
# EAPI=7
# inherit acct-user
# ACCT_USER_ID=200
# ACCT_USER_GROUPS=( foo )
# acct-user_add_deps
# @CODE
#
# Then you add appropriate dependency to your package.  The dependency
# type(s) should be:
# - DEPEND (+ RDEPEND) if the user is already needed at build time,
# - RDEPEND if it is needed at install time (e.g. you 'fowners' files
#   in pkg_preinst) or run time.

if [[ -z ${_ACCT_USER_ECLASS} ]]; then
_ACCT_USER_ECLASS=1

case ${EAPI:-0} in
	7) ;;
	*) die "EAPI=${EAPI:-0} not supported";;
esac

inherit user

[[ ${CATEGORY} == acct-user ]] ||
	die "Ebuild error: this eclass can be used only in acct-user category!"


# << Eclass variables >>

# @ECLASS-VARIABLE: ACCT_USER_NAME
# @INTERNAL
# @DESCRIPTION:
# The name of the user.  This is forced to ${PN} and the policy prohibits
# it from being changed.
ACCT_USER_NAME=${PN}
readonly ACCT_USER_NAME

# @ECLASS-VARIABLE: ACCT_USER_ID
# @REQUIRED
# @DESCRIPTION:
# Preferred UID for the new user.  This variable is obligatory, and its
# value must be unique across all user packages.
#
# Overlays should set this to -1 to dynamically allocate UID.  Using -1
# in ::gentoo is prohibited by policy.

# @ECLASS-VARIABLE: ACCT_USER_ENFORCE_ID
# @DESCRIPTION:
# If set to a non-null value, the eclass will require the user to have
# specified UID.  If the user already exists with another UID, or
# the UID is taken by another user, the install will fail.
: ${ACCT_USER_ENFORCE_ID:=}

# @ECLASS-VARIABLE: ACCT_USER_SHELL
# @DESCRIPTION:
# The shell to use for the user.  If not specified, a 'nologin' variant
# for the system is used.
: ${ACCT_USER_SHELL:=-1}

# @ECLASS-VARIABLE: ACCT_USER_HOME
# @DESCRIPTION:
# The home directory for the user.  If not specified, /dev/null is used.
# The directory will be created with appropriate permissions if it does
# not exist.  When updating, existing home directory will not be moved.
: ${ACCT_USER_HOME:=/dev/null}

# @ECLASS-VARIABLE: ACCT_USER_HOME_OWNER
# @DEFAULT_UNSET
# @DESCRIPTION:
# The ownership to use for the home directory, in chown ([user][:group])
# syntax.  Defaults to the newly created user, and its primary group.

# @ECLASS-VARIABLE: ACCT_USER_HOME_PERMS
# @DESCRIPTION:
# The permissions to use for the home directory, in chmod (octal
# or verbose) form.
: ${ACCT_USER_HOME_PERMS:=0755}

# @ECLASS-VARIABLE: ACCT_USER_GROUPS
# @REQUIRED
# @DESCRIPTION:
# List of groups the user should belong to.  This must be a bash
# array.  The first group specified is the user's primary group, while
# the remaining groups (if any) become supplementary groups.


# << Boilerplate ebuild variables >>
: ${DESCRIPTION:="System user: ${ACCT_USER_NAME}"}
: ${SLOT:=0}
: ${KEYWORDS:=alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris}
S=${WORKDIR}


# << API functions >>

# @FUNCTION: acct-user_add_deps
# @DESCRIPTION:
# Generate appropriate RDEPEND from ACCT_USER_GROUPS.  This must be
# called if ACCT_USER_GROUPS are set.
acct-user_add_deps() {
	debug-print-function ${FUNCNAME} "${@}"

	# ACCT_USER_GROUPS sanity check
	if [[ $(declare -p ACCT_USER_GROUPS) != "declare -a"* ]]; then
		die 'ACCT_USER_GROUPS must be an array.'
	elif [[ ${#ACCT_USER_GROUPS[@]} -eq 0 ]]; then
		die 'ACCT_USER_GROUPS must not be empty.'
	fi

	RDEPEND+=${ACCT_USER_GROUPS[*]/#/ acct-group/}
	_ACCT_USER_ADD_DEPS_CALLED=1
}


# << Helper functions >>

# @FUNCTION: eislocked
# @INTERNAL
# @USAGE: <user>
# @DESCRIPTION:
# Check whether the specified user account is currently locked.
# Returns 0 if it is locked, 1 if it is not, 2 if the platform
# does not support determining it.
eislocked() {
	[[ $# -eq 1 ]] || die "usage: ${FUNCNAME} <user>"

	if [[ ${EUID} != 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi

	case ${CHOST} in
	*-freebsd*|*-dragonfly*|*-netbsd*)
		[[ $(egetent "$1" | cut -d: -f2) == '*LOCKED*'* ]]
		;;

	*-openbsd*)
		return 2
		;;

	*)
		# NB: 'no password' and 'locked' are indistinguishable
		# but we also expire the account which is more clear
		[[ $(getent shadow "$1" | cut -d: -f2) == '!'* ]] &&
			[[ $(getent shadow "$1" | cut -d: -f8) == 1 ]]
		;;
	esac
}

# @FUNCTION: elockuser
# @INTERNAL
# @USAGE: <user>
# @DESCRIPTION:
# Lock the specified user account, using the available platform-specific
# functions.  This should prevent any login to the account.
#
# Established lock can be reverted using eunlockuser.
#
# This function returns 0 if locking succeeded, 2 if it is not supported
# by the platform code or dies if it fails.
elockuser() {
	[[ $# -eq 1 ]] || die "usage: ${FUNCNAME} <user>"

	if [[ ${EUID} != 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi

	eislocked "$1"
	[[ $? -eq 0 ]] && return 0

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw lock "$1" || die "Locking account $1 failed"
		pw user mod "$1" -e 1 || die "Expiring account $1 failed"
		;;

	*-netbsd*)
		usermod -e 1 -C yes "$1" || die "Locking account $1 failed"
		;;

	*-openbsd*)
		return 2
		;;

	*)
		usermod -e 1 -L "$1" || die "Locking account $1 failed"
		;;
	esac

	elog "User account $1 locked"
	return 0
}

# @FUNCTION: eunlockuser
# @INTERNAL
# @USAGE: <user>
# @DESCRIPTION:
# Unlock the specified user account, using the available platform-
# specific functions.
#
# This function returns 0 if unlocking succeeded, 1 if it is not
# supported by the platform code or dies if it fails.
eunlockuser() {
	[[ $# -eq 1 ]] || die "usage: ${FUNCNAME} <user>"

	if [[ ${EUID} != 0 ]] ; then
		einfo "Insufficient privileges to execute ${FUNCNAME[0]}"
		return 0
	fi

	eislocked "$1"
	[[ $? -eq 1 ]] && return 0

	case ${CHOST} in
	*-freebsd*|*-dragonfly*)
		pw user mod "$1" -e 0 || die "Unexpiring account $1 failed"
		pw unlock "$1" || die "Unlocking account $1 failed"
		;;

	*-netbsd*)
		usermod -e 0 -C no "$1" || die "Unlocking account $1 failed"
		;;

	*-openbsd*)
		return 1
		;;

	*)
		# silence warning if account does not have a password
		usermod -e "" -U "$1" 2>/dev/null || die "Unlocking account $1 failed"
		;;
	esac

	ewarn "User account $1 unlocked after reinstating."
	return 0
}


# << Phase functions >>
EXPORT_FUNCTIONS pkg_pretend src_install pkg_preinst pkg_postinst \
	pkg_prerm

# @FUNCTION: acct-user_pkg_pretend
# @DESCRIPTION:
# Performs sanity checks for correct eclass usage, and early-checks
# whether requested UID can be enforced.
acct-user_pkg_pretend() {
	debug-print-function ${FUNCNAME} "${@}"

	# verify that acct-user_add_deps() has been called
	# (it verifies ACCT_USER_GROUPS itself)
	if [[ -z ${_ACCT_USER_ADD_DEPS_CALLED} ]]; then
		die "Ebuild error: acct-user_add_deps must have been called in global scope!"
	fi

	# verify ACCT_USER_ID
	[[ -n ${ACCT_USER_ID} ]] || die "Ebuild error: ACCT_USER_ID must be set!"
	[[ ${ACCT_USER_ID} -eq -1 ]] && return
	[[ ${ACCT_USER_ID} -ge 0 ]] || die "Ebuild errors: ACCT_USER_ID=${ACCT_USER_ID} invalid!"

	# check for ACCT_USER_ID collisions early
	if [[ -n ${ACCT_USER_ENFORCE_ID} ]]; then
		local user_by_id=$(egetusername "${ACCT_USER_ID}")
		local user_by_name=$(egetent passwd "${ACCT_USER_NAME}")
		if [[ -n ${user_by_id} ]]; then
			if [[ ${user_by_id} != ${ACCT_USER_NAME} ]]; then
				eerror "The required UID is already taken by another user."
				eerror "  UID: ${ACCT_USER_ID}"
				eerror "  needed for: ${ACCT_USER_NAME}"
				eerror "  current user: ${user_by_id}"
				die "UID ${ACCT_USER_ID} taken already"
			fi
		elif [[ -n ${user_by_name} ]]; then
			eerror "The requested user exists already with wrong UID."
			eerror "  username: ${ACCT_USER_NAME}"
			eerror "  requested UID: ${ACCT_USER_ID}"
			eerror "  current entry: ${user_by_name}"
			die "Username ${ACCT_USER_NAME} exists with wrong UID"
		fi
	fi
}

# @FUNCTION: acct-user_src_install
# @DESCRIPTION:
# Installs a keep-file into the user's home directory to ensure it is
# owned by the package.
acct-user_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${ACCT_USER_HOME} != /dev/null ]]; then
		# note: we can't set permissions here since the user isn't
		# created yet
		keepdir "${ACCT_USER_HOME}"
	fi
}

# @FUNCTION: acct-user_pkg_preinst
# @DESCRIPTION:
# Creates the user if it does not exist yet.  Sets permissions
# of the home directory in install image.
acct-user_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"

	local groups=${ACCT_USER_GROUPS[*]}
	enewuser ${ACCT_USER_ENFORCE_ID:+-F} -M "${ACCT_USER_NAME}" \
		"${ACCT_USER_ID}" "${ACCT_USER_SHELL}" "${ACCT_USER_HOME}" \
		"${groups// /,}"

	if [[ ${ACCT_USER_HOME} != /dev/null ]]; then
		# default ownership to user:group
		if [[ -z ${ACCT_USER_HOME_OWNER} ]]; then
			ACCT_USER_HOME_OWNER=${ACCT_USER_NAME}:${ACCT_USER_GROUPS[0]}
		fi
		# Path might be missing due to INSTALL_MASK, etc.
		# https://bugs.gentoo.org/691478
		if [[ ! -e "${ED}/${ACCT_USER_HOME#/}" ]]; then
			eerror "Home directory is missing from the installation image:"
			eerror "  ${ACCT_USER_HOME}"
			eerror "Check INSTALL_MASK for entries that would cause this."
			die "${ACCT_USER_HOME} does not exist"
		fi
		fowners "${ACCT_USER_HOME_OWNER}" "${ACCT_USER_HOME}"
		fperms "${ACCT_USER_HOME_PERMS}" "${ACCT_USER_HOME}"
	fi
}

# @FUNCTION: acct-user_pkg_postinst
# @DESCRIPTION:
# Updates user properties if necessary.  This needs to be done after
# new home directory is installed.
acct-user_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	# NB: eset* functions check current value
	esethome "${ACCT_USER_NAME}" "${ACCT_USER_HOME}"
	esetshell "${ACCT_USER_NAME}" "${ACCT_USER_SHELL}"
	local groups=${ACCT_USER_GROUPS[*]}
	esetgroups "${ACCT_USER_NAME}" "${groups// /,}"
	# comment field can not contain colons
	esetcomment "${ACCT_USER_NAME}" "${DESCRIPTION//[:,=]/;}"
	eunlockuser "${ACCT_USER_NAME}"
}

# @FUNCTION: acct-user_pkg_prerm
# @DESCRIPTION:
# Ensures that the user account is locked out when it is removed.
acct-user_pkg_prerm() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		if [[ -z $(egetent passwd "${ACCT_USER_NAME}") ]]; then
			ewarn "User account not found: ${ACCT_USER_NAME}"
			ewarn "Locking process will be skipped."
			return
		fi

		esetshell "${ACCT_USER_NAME}" -1
		esetcomment "${ACCT_USER_NAME}" \
			"$(egetcomment "${ACCT_USER_NAME}"); user account removed @ $(date +%Y-%m-%d)"
		elockuser "${ACCT_USER_NAME}"
	fi
}

fi
