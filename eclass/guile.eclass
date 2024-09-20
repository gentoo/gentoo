# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: guile.eclass
# @MAINTAINER:
# Gentoo Scheme project <scheme@gentoo.org>
# @AUTHOR:
# Author: Arsen Arsenović <arsen@gentoo.org>
# Inspired by prior work in the Gentoo Python ecosystem.
# @SUPPORTED_EAPIS: 8
# @PROVIDES: guile-utils
# @BLURB: Utilities for packages multi-implementation Guile packages.
# @DESCRIPTION:
# This eclass facilitates building against many Guile implementations,
# useful for Guile libraries.  Each ebuild must set GUILE_COMPAT to a
# list of versions they support, which will be intersected with
# GUILE_TARGETS to pick which versions to install.  The eclass will
# generate a GUILE_DEPS based on the configured GUILE_COMPAT, as well as
# a GUILE_REQUIRED_USE, that the user must use.
#
# If the user of the eclass needs some USE flag on Guile itself, they
# should provide it via GUILE_REQ_USE.
#
# This ebuild provides multibuild functionality.  Use guile_foreach_impl
# to run a given command for each enabled Guile version.  The command
# provided will be ran in a modified environment, see the description of
# that function for more details.
#
# This package provides some stage functions written assuming a
# conventional GNU Build System-based Guile library and may or may not
# work.
#
# For each Guile target, a Guile library should have at least compiled
# .go files in the ccache or %site-ccache-dir.  It must also have
# corresponding sources installed in %site-dir.
#
# If your package has some steps that should only happen for one
# implementation (e.g. installing a program), you can utilize
# guile_for_best_impl.
#
# Due to http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112, Guile
# packages ought to bump their sources before building.  To this end,
# the src_prepare this eclass provides will call guile_bump_sources of
# the guile-utils eclass.
#
# When installing, the packages using this eclass ought to use
# guile_foreach_impl and its SLOTTED_{,E}D, followed by merging roots
# via guile_merge_roots and unstripping ccache objects via
# guile_unstrip_ccache.  See descriptions of those functions for
# details.
#
# Ebuild authors, please pay attention for potential conflicts between
# slots.  As an example, dev-scheme/guile-lib installs a pkg-config file
# that depends on the Guile version it is installed for.  This is not
# acceptable, as it means revdeps will only ever see the version of the
# file for the best Guile implementation in GUILE_TARGETS.
#
# @EXAMPLE:
# The following example demonstrates a simple package relying entirely
# on the setup of this eclass.  For each enabled, compatible target, the
# ebuild will bump sources (see description), and run the default
# configure, compile and test stages (per PMS, meaning GNU Build
# System), and an install stage modified such that it installs each
# variant into SLOTTED_D followed by merging roots and unstripping.
#
# @CODE
# EAPI=8
#
# GUILE_COMPAT=( 2-2 3-0 )
# inherit guile
#
# DESCRIPTION="iCalendar/vCard parser for GNU Guile"
# HOMEPAGE="https://github.com/artyom-poptsov/guile-ics"
# SRC_URI="https://github.com/artyom-poptsov/${PN}/releases/download/v${PV}/${P}.tar.gz"
#
# LICENSE="GPL-3+"
# SLOT="0"
# KEYWORDS="~amd64"
# REQUIRED_USE="${GUILE_REQUIRED_USE}"
#
# RDEPEND="
# 	${GUILE_DEPS}
# 	dev-scheme/guile-smc[${GUILE_USEDEP}]
# "
# DEPEND="${RDEPEND}"
# @CODE

case "${EAPI}" in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! "${_GUILE_ECLASS}" ]]; then
_GUILE_ECLASS=1

inherit guile-utils multibuild

# @ECLASS_VARIABLE: GUILE_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# USE dependency string that can be applied to Guile
# multi-implementation dependencies.
#
# @EXAMPLE:
# RDEPEND="
# 	${GUILE_DEPS}
# 	dev-scheme/bytestructures[${GUILE_USEDEP}]
# 	>=dev-libs/libgit2-1:=
# "
# DEPEND="${RDEPEND}"

# @ECLASS_VARIABLE: GUILE_COMPAT
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# List of acceptable versions of Guile.  For instance, setting this
# variable like below will allow the package to be built against both
# Guile 2.2 or 3.0:
#
# @CODE
# GUILE_COMPAT=( 2-2 3-0 )
# @CODE
#
# Please keep in ascending order.

_guile_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_generate_depstrings guile_targets '||'
}

_guile_setup
unset -f _guile_setup

# @ECLASS_VARIABLE: GUILE_SELECTED_TARGETS
# @INTERNAL
# @DESCRIPTION:
# Contains the intersection of GUILE_TARGETS and GUILE_COMPAT.
# Generated in guile_pkg_setup.

# @FUNCTION: guile_pkg_setup
# @DESCRIPTION:
# Sets up eclass-internal variables for this build.
guile_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_set_common_vars
	GUILE_SELECTED_TARGETS=()
	for ver in "${GUILE_COMPAT[@]}"; do
		debug-print "${FUNCNAME}: checking for ${ver}"
		use "guile_targets_${ver}" || continue
		GUILE_SELECTED_TARGETS+=("${ver/-/.}")
	done
	if [[ "${#GUILE_SELECTED_TARGETS[@]}" -eq 0 ]]; then
		die "No GUILE_TARGETS specified."
	fi
}

# @FUNCTION: guile_copy_sources
# @DESCRIPTION:
# Create a single copy of the package sources for each selected Guile
# implementation.
guile_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	MULTIBUILD_VARIANTS=("${GUILE_SELECTED_TARGETS[@]}")

	multibuild_copy_sources
}

# @FUNCTION: _guile_multibuild_wrapper
# @USAGE: <command> [<argv>...]
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for a single build variant.  See
# guile_foreach_impl.
_guile_multibuild_wrapper() {
	local GUILE_CURRENT_VERSION="${MULTIBUILD_VARIANT}"
	debug-print-function ${FUNCNAME} "${@}" "on ${MULTIBUILD_VARIANT}"

	local -x PATH="${PATH}"
	guile_create_temporary_config "${GUILE_CURRENT_VERSION}"
	guile_export GUILE GUILD GUILESNARF

	local -x PKG_CONFIG_PATH="${PKG_CONFIG_PATH}"
	guile_filter_pkgconfig_path "${MULTIBUILD_VARIANT}"
	local ECONF_SOURCE="${S}"
	local -x SLOTTED_D="${T}/dests/image${MULTIBUILD_ID}"
	local -x SLOTTED_ED="${SLOTTED_D}${EPREFIX}/"
	local -x GUILE_EFFECTIVE_VERSION="${GUILE_CURRENT_VERSION}"
	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	"$@"
	popd >/dev/null || die
}

# @VARIABLE: SLOTTED_D
# @DESCRIPTION:
# In functions ran by guile_foreach_impl, this variable is set to a new
# ${D} value that the variant being installed should use.

# @VARIABLE: SLOTTED_ED
# @DESCRIPTION:
# In functions ran by guile_foreach_impl, this variable is set to a new
# ${ED} value that the variant being installed should use.  It is
# equivalent to "${SLOTTED_D%/}${EPREFIX}/".

# @VARIABLE: ECONF_SOURCE
# @DESCRIPTION:
# In functions ran by guile_foreach_impl, this variable is set to ${S},
# for convenience.

# @VARIABLE: PKG_CONFIG_PATH
# @DESCRIPTION:
# In functions ran by guile_foreach_impl, PKG_CONFIG_PATH is filtered to
# contain only the current ${MULTIBUILD_VARIANT}.

# @VARIABLE: BUILD_DIR
# @DESCRIPTION:
# In functions ran by guile_foreach_impl, this variable is set to a
# newly-generated build directory for this variant.

# @FUNCTION: guile_foreach_impl
# @USAGE: <command> [<argv>...]
# @DESCRIPTION:
# Runs the given command for each of the selected Guile implementations.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# Each invocation will have PKG_CONFIG_DIR altered to contain only one
# Guile implementation, as well as a SLOTTED_D, SLOTTED_ED for
# installation purposes, and a new BUILD_DIR, in which the wrapped
# function will be executed, with a pre-configured ECONF_SOURCE.  A
# temporary program called 'guile-config' is generated and inserted into
# the PATH.
#
# Also automatically exported are GUILE, GUILD, and GUILESNARF - see
# guile_export for details - as well as GUILE_CURRENT_VERSION and
# GUILE_EFFECTIVE_VERSION, which are set to the same value (the current
# version).
#
# This combination should cover Guile detection of a large amount of
# packages out of the box.
guile_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	MULTIBUILD_VARIANTS=("${GUILE_SELECTED_TARGETS[@]}")

	debug-print "${FUNCNAME}: Running for each of:" \
				"${GUILE_SELECTED_TARGETS[@]}"

	multibuild_foreach_variant _guile_multibuild_wrapper "${@}"
}

# @FUNCTION: _guile_merge_single_root
# @INTERNAL
# @DESCRIPTION:
# Runs a single merge_root step for guile_merge_roots.
_guile_merge_single_root() {
	debug-print-function ${FUNCNAME} "${@}"

	multibuild_merge_root "${SLOTTED_D}" "${D}"
}

# @FUNCTION: guile_merge_roots
# @DESCRIPTION:
# Merges install roots from all slots, diagnosing conflicts.
guile_merge_roots() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_foreach_impl _guile_merge_single_root
}

# @FUNCTION: guile_for_best_impl
# @DESCRIPTION:
# Runs the passed command once, for the best installed Guile
# implementation.
guile_for_best_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	multibuild_for_best_variant _guile_multibuild_wrapper "${@}"
}

# Default implementations for a GNU Build System based Guile package.

# @FUNCTION: guile_src_prepare
# @DESCRIPTION:
# Bumps SCM sources runs the default src_prepare and bumps all *.scm
# files.  See guile_bump_sources of guile-utils.eclass.
guile_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	guile_bump_sources
}

# @FUNCTION: guile_src_configure
# @DESCRIPTION:
# Runs the default src_configure for each selected variant target.
guile_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_foreach_impl default
}

# @FUNCTION: guile_src_compile
# @DESCRIPTION:
# Runs the default src_compile for each selected variant target.
guile_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_foreach_impl default
}

# @FUNCTION: guile_src_test
# @DESCRIPTION:
# Runs the default src_test phase for each implementation.
guile_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_foreach_impl default
}

# @FUNCTION: _guile_default_install_slot
# @INTERNAL
# @DESCRIPTION:
# Imitates the default build system install "substep", but for a given
# ${SLOTTED_D} rather than the usual ${D}.  See guile_src_install.
_guile_default_install_slot() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]]; then
		emake DESTDIR="${SLOTTED_D}" install
	fi
}

# @FUNCTION: guile_src_install
# @DESCRIPTION:
# Runs the an imitation of the default src_install that does the right
# thing for a GNU Build System based Guile package, for each selected
# variant target.  Merges roots after completing the installs.
guile_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	guile_foreach_impl _guile_default_install_slot
	guile_merge_roots
	guile_unstrip_ccache

	einstalldocs
}

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile \
				 src_install src_test

fi  # _GUILE_ECLASS
