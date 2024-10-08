# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: guile-single.eclass
# @MAINTAINER:
# Gentoo Scheme project <scheme@gentoo.org>
# @AUTHOR:
# Author: Arsen Arsenović <arsen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: guile-utils
# @BLURB: Utilities for packages that build against a single Guile.
# @DESCRIPTION:
# This eclass facilitates packages building against a single slot of
# Guile, which is normally something that uses Guile for extending, like
# GNU Make, or for programs built in Guile, like Haunt.
#
# Inspired by prior work in the Gentoo Python ecosystem.
#
# These packages should use guile_gen_cond_dep to generate a dependency
# string for their Guile package dependencies (i.e. other Guile single-
# and multi-implementation packages).  They should also utilize
# GUILE_DEPS and GUILE_REQUIRED_USE to specify a dependency on their
# Guile versions.
#
# They should also bump sources via guile_bump_sources during
# src_prepare, and unstrip ccache via guile_unstrip_ccache during
# src_install.
#
# If the user of the eclass needs some USE flag on Guile itself, they
# should provide it via GUILE_REQ_USE.
#
# This eclass provides a guile-single_pkg_setup that sets up environment
# variables needed for Guile and build systems using it.  See the
# documentation for that function for more details.
#
# @EXAMPLE:
# A Guile program:
#
# @CODE
# # Copyright 2024 Gentoo Authors
# # Distributed under the terms of the GNU General Public License v2
#
# EAPI=8
#
# GUILE_COMPAT=( 2-2 3-0 )
# inherit guile-single
#
# DESCRIPTION="Haunt is a simple, functional, hackable static site generator"
# HOMEPAGE="https://dthompson.us/projects/haunt.html"
# SRC_URI="https://files.dthompson.us/releases/${PN}/${P}.tar.gz"
#
# LICENSE="GPL-3+"
# SLOT="0"
# KEYWORDS="~amd64"
# REQUIRED_USE="${GUILE_REQUIRED_USE}"
#
# RDEPEND="
# 	${GUILE_DEPS}
# 	$(guile_gen_cond_dep '
# 		dev-scheme/guile-reader[${GUILE_MULTI_USEDEP}]
# 		dev-scheme/guile-commonmark[${GUILE_MULTI_USEDEP}]
# 	')
# "
# DEPEND="${RDEPEND}"
# @CODE
#
# A program utilizing Guile for extension (GNU make, irrelevant pieces
# elided):
# @CODE
# GUILE_COMPAT=( 1-8 2-0 2-2 3-0 )
# inherit flag-o-matic unpacker verify-sig guile-single
# # ...
# REQUIRED_USE="guile? ( ${GUILE_REQUIRED_USE} )"
# DEPEND="
# 	guile? ( ${GUILE_DEPS} )
# "
#
# src_prepare() {
# 	# ...
# 	if use guile; then
# 		guile-single_src_prepare
# 	fi
# }
#
# pkg_setup() {
# 	if use guile; then
# 		guile-single_pkg_setup
# 	fi
# }
#
# src_configure() {
# 	# ...
# 	local myeconfargs=(
# 		$(use_with guile)
# 	)
# 	econf "${myeconfargs[@]}"
# }
#
# src_install() {
# 	# ...
# 	if use guile; then
# 		guile_unstrip_ccache
# 	fi
# }
# @CODE

case "${EAPI}" in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! "${_GUILE_SINGLE_ECLASS}" ]]; then
_GUILE_SINGLE_ECLASS=1

inherit guile-utils

# @ECLASS_VARIABLE: GUILE_COMPAT
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# List of acceptable versions of Guile.  For instance, setting this
# variable like below will allow the package to be built against either
# Guile 2.2 or 3.0:
#
# @CODE
# GUILE_COMPAT=( 2-2 3-0 )
# @CODE
#
# Please keep in ascending order.

_guile_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# Inhibit generating the GUILE_USEDEP.  This variable is not usable
	# for single packages.
	local GUILE_USEDEP
	guile_generate_depstrings guile_single_target ^^
}

_guile_setup
unset -f _guile_setup

# @FUNCTION: guile_gen_cond_dep
# @USAGE: <dependency> [<pattern>...]
# @DESCRIPTION:
# Takes a string that uses (quoted) ${GUILE_SINGLE_USEDEP} and
# ${GUILE_MULTI_USEDEP} markers as placeholders for the correct USE
# dependency strings for each compatible slot.
#
# If the pattern is provided, it is taken to be list of slots to
# generate the dependency string for, otherwise, ${GUILE_COMPAT[@]} is
# taken.
#
# @EXAMPLE:
# Note that the "inner" dependency string is in single quotes!
# @CODE
# RDEPEND="
#	$(guile_gen_cond_dep '
#		dev-scheme/guile-zstd[${GUILE_MULTI_USEDEP}]
#		dev-scheme/guile-config[${GUILE_SINGLE_USEDEP}]
#	')
# "
# @CODE
guile_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "$@"

	local deps="$1"
	shift

	local candidates=( "$@" )
	if [[ ${#candidates[@]} -eq 0 ]]; then
		candidates=( "${GUILE_COMPAT[@]}" )
	fi

	local candidate
	for candidate in "${candidates[@]}"; do
		local s="guile_single_target_${candidate}(-)" \
			  m="guile_targets_${candidate}(-)" \
			  subdeps=${deps//\$\{GUILE_SINGLE_USEDEP\}/${s}}
		subdeps=${subdeps//\$\{GUILE_MULTI_USEDEP\}/${m}}
		echo "
		guile_single_target_${candidate}? (
			${subdeps}
		)
		"
	done
}

# @FUNCTION: guile-single_pkg_setup
# @DESCRIPTION:
# Sets up the PKG_CONFIG_PATH with the appropriate GUILE_SINGLE_TARGET,
# as well as setting up a guile-config and the GUILE, GUILD and
# GUILESNARF environment variables.  Also sets GUILE_EFFECTIVE_VERSION
# to the same value as GUILE_SELECTED_TARGET, as build systems sometimes
# check that variable.
#
# For details on the latter three, see guile_export.
guile-single_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	guile_set_common_vars

	GUILE_SELECTED_TARGET=
	for ver in "${GUILE_COMPAT[@]}"; do
		debug-print "${FUNCNAME}: checking for ${ver}"
		use "guile_single_target_${ver}" || continue
		GUILE_SELECTED_TARGET="${ver/-/.}"
		break
	done

	[[ ${GUILE_SELECTED_TARGET} ]] \
		|| die "No GUILE_SINGLE_TARGET specified."

	export PKG_CONFIG_PATH
	guile_filter_pkgconfig_path "${GUILE_SELECTED_TARGET}"
	guile_create_temporary_config "${GUILE_SELECTED_TARGET}"
	local -x GUILE_EFFECTIVE_VERSION="${GUILE_SELECTED_TARGET}"
	guile_export GUILE GUILD GUILESNARF
}

# @FUNCTION: guile-single_src_prepare
# @DESCRIPTION:
# Runs the default prepare stage, and then bumps Guile sources via
# guile_bump_sources.
guile-single_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	default
	guile_bump_sources
}

# @FUNCTION: guile-single_src_install
# @DESCRIPTION:
# Runs the default install stage, and then marks ccache files not to be
# stripped using guile_unstrip_ccache.
guile-single_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	default
	guile_unstrip_ccache
}

fi  # _GUILE_SINGLE_ECLASS

EXPORT_FUNCTIONS pkg_setup src_prepare src_install
