# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

inherit multibuild postgres
EXPORT_FUNCTIONS pkg_setup src_prepare src_compile src_install src_test


# @ECLASS: postgres-multi.eclass
# @MAINTAINER:
# PostgreSQL <pgsql-bugs@gentoo.org>
# @AUTHOR:
# Aaron W. Swenson <titanofold@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: An eclass to build PostgreSQL-related packages against multiple slots
# @DESCRIPTION:
# postgres-multi enables ebuilds, particularly PostgreSQL extensions, to
# build and install for one or more PostgreSQL slots as specified by
# POSTGRES_TARGETS use flags.


case ${EAPI:-0} in
	5|6|7) ;;
	*) die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac


# @ECLASS-VARIABLE: POSTGRES_COMPAT
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# A Bash array containing a list of compatible PostgreSQL slots as
# defined by the developer. Must be declared before inheriting this
# eclass. Example:
#@CODE
#POSTGRES_COMPAT=( 9.2 9.3 9.4 9.5 9.6 10 )
#POSTGRES_COMPAT=( 9.{2,3} 9.{4..6} 10 ) # Same as previous
#@CODE
if ! declare -p POSTGRES_COMPAT &>/dev/null; then
	die 'Required variable POSTGRES_COMPAT not declared.'
fi

# @ECLASS-VARIABLE: _POSTGRES_INTERSECT_SLOTS
# @INTERNAL
# @DESCRIPTION:
# A Bash array containing the intersect of POSTGRES_TARGETS and
# POSTGRES_COMPAT.
export _POSTGRES_INTERSECT_SLOTS=( )

# @FUNCTION: _postgres-multi_multibuild_wrapper
# @USAGE: <command> [arg ...]
# @INTERNAL
# @DESCRIPTION:
# For the given variant, set the values of the PG_SLOT, PG_CONFIG, and
# PKG_CONFIG_PATH environment variables accordingly and replace any
# appearance of @PG_SLOT@ in the command and arguments with value of
# ${PG_SLOT}.
_postgres-multi_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"
	export PG_SLOT=${MULTIBUILD_VARIANT}
	export PG_CONFIG=$(which pg_config${MULTIBUILD_VARIANT//./})
	if [[ -n ${PKG_CONFIG_PATH} ]] ; then
		PKG_CONFIG_PATH="$(${PG_CONFIG} --libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	else
		PKG_CONFIG_PATH="$(${PG_CONFIG} --libdir)/pkgconfig"
	fi
	export PKG_CONFIG_PATH

	$(echo "${@}" | sed "s/@PG_SLOT@/${PG_SLOT}/g")
}

# @FUNCTION: postgres-multi_foreach
# @USAGE: <command> [arg ...]
# @DESCRIPTION:
# Run the given command in the package's build directory for each
# PostgreSQL slot in the intersect of POSTGRES_TARGETS and
# POSTGRES_COMPAT. The PG_CONFIG and PKG_CONFIG_PATH environment
# variables are updated on each iteration to point to the matching
# pg_config command and pkg-config metadata files, respectively, for the
# current slot. Any appearance of @PG_SLOT@ in the command or arguments
# will be substituted with the slot (e.g., 9.5) of the current
# iteration.
postgres-multi_foreach() {
	local MULTIBUILD_VARIANTS=("${_POSTGRES_INTERSECT_SLOTS[@]}")

	multibuild_foreach_variant \
		_postgres-multi_multibuild_wrapper run_in_build_dir ${@}
}

# @FUNCTION: postgres-multi_forbest
# @USAGE: <command> [arg ...]
# @DESCRIPTION:
# Run the given command in the package's build directory for the highest
# slot in the intersect of POSTGRES_COMPAT and POSTGRES_TARGETS. The
# PG_CONFIG and PKG_CONFIG_PATH environment variables are set to the
# matching pg_config command and pkg-config metadata files,
# respectively. Any appearance of @PG_SLOT@ in the command or arguments
# will be substituted with the matching slot (e.g., 9.5).
postgres-multi_forbest() {
	# POSTGRES_COMPAT is reverse sorted once in postgres.eclass so
	# element 0 has the highest slot version.
	local MULTIBUILD_VARIANTS=("${_POSTGRES_INTERSECT_SLOTS[0]}")

	multibuild_foreach_variant \
		_postgres-multi_multibuild_wrapper run_in_build_dir ${@}
}

# @FUNCTION: postgres-multi_pkg_setup
# @DESCRIPTION:
# Initialize internal environment variable(s). This is required if
# pkg_setup() is declared in the ebuild.
postgres-multi_pkg_setup() {
	local user_slot

	# _POSTGRES_COMPAT is created in postgres.eclass
	for user_slot in "${_POSTGRES_COMPAT[@]}"; do
		use "postgres_targets_postgres${user_slot/\./_}" && \
			_POSTGRES_INTERSECT_SLOTS+=( "${user_slot}" )
	done

	if [[ "${#_POSTGRES_INTERSECT_SLOTS[@]}" -eq "0" ]]; then
		die "One of the postgres_targets_postgresSL_OT use flags must be enabled"
	fi

	einfo "Multibuild variants: ${_POSTGRES_INTERSECT_SLOTS[@]}"
}

# @FUNCTION: postgres-multi_src_prepare
# @DESCRIPTION:
# Calls eapply_user then copies ${S} into a build directory for each
# intersect of POSTGRES_TARGETS and POSTGRES_COMPAT.
postgres-multi_src_prepare() {
	if [[ "${#_POSTGRES_INTERSECT_SLOTS[@]}" -eq "0" ]]; then
		eerror "Internal array _POSTGRES_INTERSECT_SLOTS is empty."
		die "Did you forget to call postgres-multi_pkg_setup?"
	fi

	# Check that the slot has been emerged (Should be prevented by
	# Portage, but won't be caught by /usr/bin/ebuild)
	local slot
	for slot in ${_POSTGRES_INTERSECT_SLOTS[@]} ; do
		if [[ -z $(which pg_config${slot/.} 2> /dev/null) ]] ; then
			eerror
			eerror "postgres_targets_postgres${slot/.} use flag is enabled, but hasn't been emerged."
			eerror
			die "a postgres_targets use flag is enabled, but not emerged"
		fi
	done

	case ${EAPI:-0} in
		0|1|2|3|4|5) epatch_user ;;
		6|7) eapply_user ;;
	esac

	local MULTIBUILD_VARIANT
	local MULTIBUILD_VARIANTS=("${_POSTGRES_INTERSECT_SLOTS[@]}")
	multibuild_copy_sources
}

# @FUNCTION: postgres-multi_src_compile
# @DESCRIPTION:
# Runs `emake' in each build directory
postgres-multi_src_compile() {
	postgres-multi_foreach emake
}

# @FUNCTION: postgres-multi_src_install
# @DESCRIPTION:
# Runs `emake install DESTDIR="${D}"' in each build directory.
postgres-multi_src_install() {
	postgres-multi_foreach emake install DESTDIR="${D}"
}

# @FUNCTION: postgres-multi_src_test
# @DESCRIPTION:
# Runs `emake installcheck' in each build directory.
postgres-multi_src_test() {
	postgres-multi_foreach emake installcheck
}
