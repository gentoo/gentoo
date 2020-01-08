# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: acct-group.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michael Orlitzky <mjo@gentoo.org>
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass used to create and maintain a single group entry
# @DESCRIPTION:
# This eclass represents and creates a single group entry.  The name
# of the group is derived from ${PN}, while (preferred) GID needs to
# be specified via ACCT_GROUP_ID.  Packages (and users) needing the group
# in question should depend on the package providing it.
#
# Example:
# If your package needs group 'foo', you create 'acct-group/foo' package
# and add an ebuild with the following contents:
#
# @CODE
# EAPI=7
# inherit acct-group
# ACCT_GROUP_ID=200
# @CODE
#
# Then you add appropriate dependency to your package.  The dependency
# type(s) should be:
# - DEPEND (+ RDEPEND) if the group is already needed at build time,
# - RDEPEND if it is needed at install time (e.g. you 'fowners' files
#   in pkg_preinst) or run time.

if [[ -z ${_ACCT_GROUP_ECLASS} ]]; then
_ACCT_GROUP_ECLASS=1

case ${EAPI:-0} in
	7) ;;
	*) die "EAPI=${EAPI:-0} not supported";;
esac

inherit user

[[ ${CATEGORY} == acct-group ]] ||
	die "Ebuild error: this eclass can be used only in acct-group category!"


# << Eclass variables >>

# @ECLASS-VARIABLE: ACCT_GROUP_NAME
# @INTERNAL
# @DESCRIPTION:
# The name of the group.  This is forced to ${PN} and the policy
# prohibits it from being changed.
ACCT_GROUP_NAME=${PN}
readonly ACCT_GROUP_NAME

# @ECLASS-VARIABLE: ACCT_GROUP_ID
# @REQUIRED
# @DESCRIPTION:
# Preferred GID for the new group.  This variable is obligatory, and its
# value must be unique across all group packages.
#
# Overlays should set this to -1 to dynamically allocate GID.  Using -1
# in ::gentoo is prohibited by policy.

# @ECLASS-VARIABLE: ACCT_GROUP_ENFORCE_ID
# @DESCRIPTION:
# If set to a non-null value, the eclass will require the group to have
# specified GID.  If the group already exists with another GID, or
# the GID is taken by another group, the install will fail.
: ${ACCT_GROUP_ENFORCE_ID:=}


# << Boilerplate ebuild variables >>
: ${DESCRIPTION:="System group: ${ACCT_GROUP_NAME}"}
: ${SLOT:=0}
: ${KEYWORDS:=alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris}
S=${WORKDIR}


# << Phase functions >>
EXPORT_FUNCTIONS pkg_pretend pkg_preinst

# @FUNCTION: acct-group_pkg_pretend
# @DESCRIPTION:
# Performs sanity checks for correct eclass usage, and early-checks
# whether requested GID can be enforced.
acct-group_pkg_pretend() {
	debug-print-function ${FUNCNAME} "${@}"

	# verify ACCT_GROUP_ID
	[[ -n ${ACCT_GROUP_ID} ]] || die "Ebuild error: ACCT_GROUP_ID must be set!"
	[[ ${ACCT_GROUP_ID} -eq -1 ]] && return
	[[ ${ACCT_GROUP_ID} -ge 0 ]] || die "Ebuild errors: ACCT_GROUP_ID=${ACCT_GROUP_ID} invalid!"

	# check for ACCT_GROUP_ID collisions early
	if [[ -n ${ACCT_GROUP_ENFORCE_ID} ]]; then
		local group_by_id=$(egetgroupname "${ACCT_GROUP_ID}")
		local group_by_name=$(egetent group "${ACCT_GROUP_NAME}")
		if [[ -n ${group_by_id} ]]; then
			if [[ ${group_by_id} != ${ACCT_GROUP_NAME} ]]; then
				eerror "The required GID is already taken by another group."
				eerror "  GID: ${ACCT_GROUP_ID}"
				eerror "  needed for: ${ACCT_GROUP_NAME}"
				eerror "  current group: ${group_by_id}"
				die "GID ${ACCT_GROUP_ID} taken already"
			fi
		elif [[ -n ${group_by_name} ]]; then
			eerror "The requested group exists already with wrong GID."
			eerror "  groupname: ${ACCT_GROUP_NAME}"
			eerror "  requested GID: ${ACCT_GROUP_ID}"
			eerror "  current entry: ${group_by_name}"
			die "Group ${ACCT_GROUP_NAME} exists with wrong GID"
		fi
	fi
}

# @FUNCTION: acct-group_pkg_preinst
# @DESCRIPTION:
# Creates the group if it does not exist yet.
acct-group_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"

	enewgroup ${ACCT_GROUP_ENFORCE_ID:+-F} "${ACCT_GROUP_NAME}" \
		"${ACCT_GROUP_ID}"
}

fi
