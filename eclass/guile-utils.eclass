# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: guile-utils.eclass
# @MAINTAINER:
# Gentoo Scheme project <scheme@gentoo.org>
# @AUTHOR:
# Author: Arsen Arsenović <arsen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common code between GNU Guile-related eclasses and ebuilds.
# @DESCRIPTION:
# This eclass contains various bits of common code between
# dev-scheme/guile, Guile multi-implementation ebuilds and Guile
# single-implementation ebuilds.
#
# Inspired by prior work in the Gentoo Python ecosystem.

case "${EAPI}" in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! "${_GUILE_UTILS_ECLASS}" ]]; then
_GUILE_UTILS_ECLASS=1

inherit toolchain-funcs

BDEPEND="virtual/pkgconfig"

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

# @FUNCTION: guile_check_compat
# @DESCRIPTION:
# Checks that GUILE_COMPAT is set to an array, and has no invalid
# values.
guile_check_compat() {
	debug-print-function ${FUNCNAME} "${@}"

	if ! [[ ${GUILE_COMPAT@a} == *a* ]]; then
		die "GUILE_COMPAT not set to an array"
	fi

	if [[ ${#GUILE_COMPAT[@]} -eq 0 ]]; then
		die "GUILE_COMPAT is empty"
	fi
}

guile_check_compat

# @ECLASS_VARIABLE: GUILE_REQ_USE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies a USE dependency string for all versions of Guile in
# GUILE_COMPAT.
#
# @EXAMPLE:
# GUILE_REQ_USE="deprecated"

# @ECLASS_VARIABLE: GUILE_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This variable is populated with a USE-dependency string which can be
# used to depend on other Guile multi-implementation packages.
# This variable is not usable from guile-single packages.

# @ECLASS_VARIABLE: GUILE_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Contains the dependency string for the compatible Guile runtimes.

# @FUNCTION: guile_set_common_vars
# @DESCRIPTION:
# Sets common variables that apply to all Guile packages, namely,
# QA_PREBUILT.
guile_set_common_vars() {
	debug-print-function ${FUNCNAME} "${@}"

	# These aren't strictly speaking prebuilt. but they do generated a
	# nonstandard ELF object.
	if [[ -z ${QA_PREBUILT} ]]; then
		QA_PREBUILT="usr/$(get_libdir)/guile/*/site-ccache/*"
	fi
}

# @FUNCTION: guile_filter_pkgconfig_path
# @USAGE: <acceptable slots>...
# @DESCRIPTION:
# Alters ${PKG_CONFIG_PATH} such that it does not contain any Guile
# slots besides the ones required by the caller.
guile_filter_pkgconfig_path() {
	debug-print-function ${FUNCNAME} "${@}"

	local filtered_path= unfiltered_path path
	IFS=: read -ra unfiltered_path <<<"${PKG_CONFIG_PATH}"
	debug-print "Unfiltered PKG_CONFIG_PATH:" "${unfiltered_path[@]}"
	for p in "${unfiltered_path[@]}"; do
		for v in "$@"; do
			debug-print "... considering '${p}' for ${v}"
			# Exclude non-selected versions.
			[[ ${p} == */usr/share/guile-data/${v}/pkgconfig* ]] \
				|| continue
			debug-print "... OK"

			# Add separator, if some data already exists.
			[[ "${filtered_path}" ]] && filtered_path+=:

			filtered_path+="${p}"
			break
		done
	done

	debug-print "${FUNCNAME}: Constructed PKG_CONFIG_PATH: ${filtered_path}"
	PKG_CONFIG_PATH="$filtered_path"
}

# @FUNCTION: guile_generate_depstrings
# @USAGE: <prefix> <depop>
# @DESCRIPTION:
# Generates GUILE_REQUIRED_USE/GUILE_DEPS/GUILE_USEDEP based on
# GUILE_COMPAT, and populates IUSE.
guile_generate_depstrings() {
	debug-print-function ${FUNCNAME} "${@}"

	# Generate IUSE, REQUIRED_USE, GUILE_USEDEP
	local prefix="$1" depop="$2"
	GUILE_USEDEP=""
	local ver uses=()
	# TODO(arsen): enforce GUILE_COMPAT is in ascending order.
	for ver in "${GUILE_COMPAT[@]}"; do
		[[ -n ${GUILE_USEDEP} ]] && GUILE_USEDEP+=","
		uses+=("${prefix}_${ver}")
		GUILE_USEDEP+="${prefix}_${ver}"
	done
	GUILE_REQUIRED_USE="${depop} ( ${uses[@]} )"
	IUSE="${uses[@]}"
	debug-print "${FUNCNAME}: requse ${GUILE_REQUIRED_USE}"
	debug-print "${FUNCNAME}: generated ${uses[*]}"
	debug-print "${FUNCNAME}: iuse ${IUSE}"

	# Generate GUILE_DEPS
	local base_deps=()
	local requse="${GUILE_REQ_USE+[}${GUILE_REQ_USE:-}${GUILE_REQ_USE+]}"
	for ver in "${GUILE_COMPAT[@]}"; do
		base_deps+="
			${prefix}_${ver}? (
				dev-scheme/guile:${ver/-/.}${requse}
			)
		"
	done
	GUILE_DEPS="${base_deps[*]}"
	debug-print "${FUNCNAME}: GUILE_DEPS=${GUILE_DEPS}"
	debug-print "${FUNCNAME}: GUILE_USEDEP=${GUILE_USEDEP}"
}

# @FUNCTION: guile_unstrip_ccache
# @DESCRIPTION:
# Marks site-ccache files not to be stripped.  Operates on ${D}.
guile_unstrip_ccache() {
	debug-print-function ${FUNCNAME} "${@}"

	local ccache
	while read -r -d $'\0' ccache; do
		debug-print "${FUNCNAME}: ccache found: ${ccache#.}"
		dostrip -x "${ccache#.}"
	done < <(cd "${ED}" || die; \
			 find . \
				  -name '*.go' \
				  -path "*/usr/$(get_libdir)/guile/*/site-ccache/*" \
				  -print0 || die) || die
}

# @FUNCTION: guile_export
# @USAGE: [GUILE|GUILD|GUILE_SITECCACHEDIR|GUILE_SITEDIR]...
# @DESCRIPTION:
# Exports a given variable for the selected Guile variant.
#
# Supported variables are:
#
# - GUILE - Path to the guile executable,
# - GUILD - Path to the guild executable,
# - GUILESNARF - Path to the guile-snarf executable
# - GUILECONFIG - Path to the guile-config executable
# - GUILE_SITECCACHEDIR - Path to the site-ccache directory,
# - GUILE_SITEDIR - Path to the site Scheme directory
guile_export() {
	debug-print-function ${FUNCNAME} "${@}"

	local gver
	if [[ "${GUILE_CURRENT_VERSION}" ]]; then
		gver="${GUILE_CURRENT_VERSION}"
	elif [[ "${GUILE_SELECTED_TARGET}" ]]; then
		gver="${GUILE_SELECTED_TARGET}"
	else
		die "Calling guile_export outside of a Guile build context?"
	fi

	_guile_pcvar() {
		local tip="Did you source /etc/profile after an update?"
		$(tc-getPKG_CONFIG) --variable="$1" guile-"${gver}" \
			|| die "Could not get $1 out of guile-${gver}.  ${tip}"
	}

	for var; do
		case "${var}" in
			GUILE) export GUILE="$(_guile_pcvar guile)" ;;
			GUILD) export GUILD="$(_guile_pcvar guild)" ;;
			GUILESNARF)
				GUILESNARF="${EPREFIX}/usr/bin/guile-snarf-${gver}"
				export GUILESNARF
				;;
			GUILECONFIG)
				GUILECONFIG="${EPREFIX}/usr/bin/guile-config-${gver}"
				export GUILECONFIG
				;;
			GUILE_SITECCACHEDIR)
				GUILE_SITECCACHEDIR="$(_guile_pcvar siteccachedir)"
				export GUILE_SITECCACHEDIR
				;;
			GUILE_SITEDIR)
				export GUILE_SITEDIR="$(_guile_pcvar sitedir)"
				;;
			*) die "Unknown variable '${var}'" ;;
		esac
	done
}

# @FUNCTION: guile_create_temporary_config
# @USAGE: <version>
# @DESCRIPTION:
# Creates a guile-config executable for a given Guile version, and
# inserts it into path.
guile_create_temporary_config() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${1} ]] || die "Must specify a Guile version"

	local cdir="${T}/guiles/${1}/"
	mkdir -p "${cdir}" || die

	pushd "${cdir}" >/dev/null 2>&1 || die
	cat >guile-config <<-EOF
	#!/bin/sh
	exec guile-config-${1} "\${@}"
	EOF
	chmod +x guile-config
	popd >/dev/null 2>&1 || die
	PATH="${cdir}:${PATH}"
}

# @FUNCTION: guile_bump_sources
# @DESCRIPTION:
# Searches over ${S} for .scm files and bumps them to avoid Guile using
# the system ccache while trying to build packages.
#
# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
guile_bump_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	einfo "bumping *.scm source files..."
	find "${S}" -name "*.scm" -exec touch {} + || die
}

fi  # _GUILE_UTILS_ECLASS
