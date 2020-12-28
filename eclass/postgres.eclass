# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

inherit user
EXPORT_FUNCTIONS pkg_setup

# @ECLASS: postgres.eclass
# @MAINTAINER:
# PostgreSQL <pgsql-bugs@gentoo.org>
# @AUTHOR: Aaron W. Swenson <titanofold@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: An eclass for PostgreSQL-related packages
# @DESCRIPTION:
# This eclass provides common utility functions that many
# PostgreSQL-related packages perform, such as checking that the
# currently selected PostgreSQL slot is within a range, adding a system
# user to the postgres system group, and generating dependencies.


case ${EAPI:-0} in
	5|6|7) ;;
	*) die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

# @ECLASS-VARIABLE: _POSTGRES_ALL_VERSIONS
# @INTERNAL
# @DESCRIPTION:
# List of versions to reverse sort POSTGRES_COMPAT slots

_POSTGRES_ALL_VERSIONS=( 9999 13 12 11 10 9.6 9.5 9.4 9.3 9.2 )



# @ECLASS-VARIABLE: POSTGRES_COMPAT
# @DEFAULT_UNSET
# @DESCRIPTION:
# A Bash array containing a list of compatible PostgreSQL slots as
# defined by the developer. If declared, must be declared before
# inheriting this eclass. Example:
#@CODE
#POSTGRES_COMPAT=( 9.2 9.3 9.4 9.5 9.6 10 )
#POSTGRES_COMPAT=( 9.{2,3} 9.{4..6} 10 ) # Same as previous
#@CODE

# @ECLASS-VARIABLE: POSTGRES_DEP
# @DESCRIPTION:
# An automatically generated dependency string suitable for use in
# DEPEND and RDEPEND declarations.
POSTGRES_DEP="dev-db/postgresql:="

# @ECLASS-VARIABLE: POSTGRES_USEDEP
# @DEFAULT_UNSET
# @DESCRIPTION:
# Add the 2-Style and/or 4-Style use dependencies without brackets to be used
# for POSTGRES_DEP. If declared, must be declared before inheriting this eclass.
declare -p POSTGRES_USEDEP &>/dev/null && POSTGRES_DEP+="[${POSTGRES_USEDEP}]"

# @ECLASS-VARIABLE: POSTGRES_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# An automatically generated REQUIRED_USE-compatible string built upon
# POSTGRES_COMPAT. REQUIRED_USE="... ${POSTGRES_REQ_USE}" is only
# required if the package must build against one of the PostgreSQL slots
# declared in POSTGRES_COMPAT.

# @ECLASS-VARIABLE: _POSTGRES_COMPAT
# @INTERNAL
# @DESCRIPTION:
# Copy of POSTGRES_COMPAT, reverse sorted
_POSTGRES_COMPAT=()


if declare -p POSTGRES_COMPAT &> /dev/null ; then
	# Reverse sort the given POSTGRES_COMPAT so that the most recent
	# slot is preferred over an older slot.
	# -- do we care if dependencies are deterministic by USE flags?
	for i in ${_POSTGRES_ALL_VERSIONS[@]} ; do
		has ${i} ${POSTGRES_COMPAT[@]} && _POSTGRES_COMPAT+=( ${i} )
	done

	POSTGRES_DEP=""
	POSTGRES_REQ_USE=" || ("
	for slot in "${_POSTGRES_COMPAT[@]}" ; do
		POSTGRES_DEP+=" postgres_targets_postgres${slot/\./_}? ( dev-db/postgresql:${slot}="
		declare -p POSTGRES_USEDEP &>/dev/null && \
			POSTGRES_DEP+="[${POSTGRES_USEDEP}]"
		POSTGRES_DEP+=" )"

		IUSE+=" postgres_targets_postgres${slot/\./_}"
		POSTGRES_REQ_USE+=" postgres_targets_postgres${slot/\./_}"
	done
	POSTGRES_REQ_USE+=" )"
fi


# @FUNCTION: postgres_check_slot
# @DESCRIPTION:
# Verify that the currently selected PostgreSQL slot is set to one of
# the slots defined in POSTGRES_COMPAT. Automatically dies unless a
# POSTGRES_COMPAT slot is selected. Should be called in pkg_pretend().
postgres_check_slot() {
	if ! declare -p POSTGRES_COMPAT &>/dev/null; then
		die 'POSTGRES_COMPAT not declared.'
	fi

	# Don't die because we can't run postgresql-config during pretend.
	[[ "$EBUILD_PHASE" = "pretend" && -z "$(which postgresql-config 2> /dev/null)" ]] \
		&& return 0

	if has $(postgresql-config show 2> /dev/null) "${POSTGRES_COMPAT[@]}"; then
		return 0
	else
		eerror "PostgreSQL slot must be set to one of: "
		eerror "    ${POSTGRES_COMPAT[@]}"
		die "Incompatible PostgreSQL slot eselected"
	fi
}

# @FUNCTION: postgres_new_user
# @USAGE: [user [(uid|-1) [(shell|-1) [(homedir|-1) [groups]]]]]
# @DESCRIPTION:
# Creates the "postgres" system group and user -- which is separate from
# the database user -- and, optionally, the developer defined user. There
# are no required parameters.
#
# When given a user to create, it'll be created with the next available
# uid, default shell set to /bin/false, default homedir is /dev/null,
# and added to the "postgres" system group. You can use "-1" to skip any
# parameter except user or groups.
postgres_new_user() {
	enewgroup postgres 70
	enewuser postgres 70 /bin/bash /var/lib/postgresql postgres

	if [[ $# -gt 0 ]] ; then
		if [[ "$1" = "postgres" ]] ; then
			ewarn "Username 'postgres' implied, skipping"
		else
			local groups=$5
			[[ -n "${groups}" ]] && groups+=",postgres" || groups="postgres"
			enewuser "$1" "${2:--1}" "${3:--1}" "${4:--1}" "${groups}"
		fi
	fi
}

# @FUNCTION: postgres_pkg_setup
# @DESCRIPTION:
# Initialize environment variable(s) according to the best
# installed version of PostgreSQL that is also in POSTGRES_COMPAT. This
# is required if pkg_setup() is declared in the ebuild.
# Exports PG_SLOT, PG_CONFIG, and PKG_CONFIG_PATH.
postgres_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local compat_slot
	local best_slot
	for compat_slot in "${_POSTGRES_COMPAT[@]}"; do
		if use "postgres_targets_postgres${compat_slot/\./_}"; then
			best_slot="${compat_slot}"
			break
		fi
	done

	if [[ -z "${best_slot}" ]]; then
		local flags f
		for f in "${_POSTGRES_COMPAT[@]}"; do
			flags+=" postgres${f/./_}"
		done

		eerror "POSTGRES_TARGETS must contain at least one of:"
		eerror "    ${flags}"
		die "No suitable POSTGRES_TARGETS enabled."
	fi

	export PG_SLOT=${best_slot}
	export PG_CONFIG=$(which pg_config${best_slot//./})

	local pg_pkg_config_path="$(${PG_CONFIG} --libdir)/pkgconfig"
	if [[ -n "${PKG_CONFIG_PATH}" ]]; then
		export PKG_CONFIG_PATH="${pg_pkg_config_path}:${PKG_CONFIG_PATH}"
	else
		export PKG_CONFIG_PATH="${pg_pkg_config_path}"
	fi

	elog "PostgreSQL Target: ${best_slot}"
}
