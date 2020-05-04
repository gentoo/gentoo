# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rebar.eclass
# @MAINTAINER:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# @AUTHOR:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# @SUPPORTED_EAPIS: 6
# @BLURB: Build Erlang/OTP projects using dev-util/rebar.
# @DESCRIPTION:
# An eclass providing functions to build Erlang/OTP projects using
# dev-util/rebar.
#
# rebar is a tool which tries to resolve dependencies itself which is by
# cloning remote git repositories. Dependant projects are usually expected to
# be in sub-directory 'deps' rather than looking at system Erlang lib
# directory. Projects relying on rebar usually don't have 'install' make
# targets. The eclass workarounds some of these problems. It handles
# installation in a generic way for Erlang/OTP structured projects.

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_prepare src_compile src_test src_install

RDEPEND="dev-lang/erlang:="
DEPEND="${RDEPEND}
	dev-util/rebar
	>=sys-apps/gawk-4.1"

# @ECLASS-VARIABLE: REBAR_APP_SRC
# @DESCRIPTION:
# Relative path to .app.src description file.
REBAR_APP_SRC="${REBAR_APP_SRC-src/${PN}.app.src}"

# @FUNCTION: get_erl_libs
# @RETURN: the path to Erlang lib directory
# @DESCRIPTION:
# Get the full path without EPREFIX to Erlang lib directory.
get_erl_libs() {
	echo "/usr/$(get_libdir)/erlang/lib"
}

# @FUNCTION: _rebar_find_dep
# @INTERNAL
# @USAGE: <project_name>
# @RETURN: full path with EPREFIX to a Erlang package/project on success,
# code 1 when dependency is not found and code 2 if multiple versions of
# dependency are found.
# @DESCRIPTION:
# Find a Erlang package/project by name in Erlang lib directory. Project
# directory is usually suffixed with version. It is matched to '<project_name>'
# or '<project_name>-*'.
_rebar_find_dep() {
	local pn="$1"
	local p
	local result

	pushd "${EPREFIX}$(get_erl_libs)" >/dev/null || return 1
	for p in ${pn} ${pn}-*; do
		if [[ -d ${p} ]]; then
			# Ensure there's at most one matching.
			[[ ${result} ]] && return 2
			result="${p}"
		fi
	done
	popd >/dev/null || die

	[[ ${result} ]] || return 1
	echo "${result}"
}

# @FUNCTION: rebar_disable_coverage
# @USAGE: [<rebar_config>]
# @DESCRIPTION:
# Disable coverage in rebar.config. This is a workaround for failing coverage.
# Coverage is not relevant in this context, so there's no harm to disable it,
# although the issue should be fixed.
rebar_disable_coverage() {
	debug-print-function ${FUNCNAME} "${@}"

	local rebar_config="${1:-rebar.config}"

	sed -e 's/{cover_enabled, true}/{cover_enabled, false}/' \
		-i "${rebar_config}" \
		|| die "failed to disable coverage in ${rebar_config}"
}

# @FUNCTION: erebar
# @USAGE: <targets>
# @DESCRIPTION:
# Run rebar with verbose flag. Die on failure.
erebar() {
	debug-print-function ${FUNCNAME} "${@}"

	(( $# > 0 )) || die "erebar: at least one target is required"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	[[ ${1} == eunit ]] && local -x ERL_LIBS="."

	rebar -v skip_deps=true "$@" || die -n "rebar $@ failed"
}

# @FUNCTION: rebar_fix_include_path
# @USAGE: <project_name> [<rebar_config>]
# @DESCRIPTION:
# Fix path in rebar.config to 'include' directory of dependant project/package,
# so it points to installation in system Erlang lib rather than relative 'deps'
# directory.
#
# <rebar_config> is optional. Default is 'rebar.config'.
#
# The function dies on failure.
rebar_fix_include_path() {
	debug-print-function ${FUNCNAME} "${@}"

	local pn="$1"
	local rebar_config="${2:-rebar.config}"
	local erl_libs="${EPREFIX}$(get_erl_libs)"
	local p

	p="$(_rebar_find_dep "${pn}")" \
		|| die "failed to unambiguously resolve dependency of '${pn}'"

	gawk -i inplace \
		-v erl_libs="${erl_libs}" -v pn="${pn}" -v p="${p}" '
/^{[[:space:]]*erl_opts[[:space:]]*,/, /}[[:space:]]*\.$/ {
	pattern = "\"(./)?deps/" pn "/include\"";
	if (match($0, "{i,[[:space:]]*" pattern "[[:space:]]*}")) {
		sub(pattern, "\"" erl_libs "/" p "/include\"");
	}
	print $0;
	next;
}
1
' "${rebar_config}" || die "failed to fix include paths in ${rebar_config} for '${pn}'"
}

# @FUNCTION: rebar_remove_deps
# @USAGE: [<rebar_config>]
# @DESCRIPTION:
# Remove dependencies list from rebar.config and deceive build rules that any
# dependencies are already fetched and built. Otherwise rebar tries to fetch
# dependencies and compile them.
#
# <rebar_config> is optional. Default is 'rebar.config'.
#
# The function dies on failure.
rebar_remove_deps() {
	debug-print-function ${FUNCNAME} "${@}"

	local rebar_config="${1:-rebar.config}"

	mkdir -p "${S}/deps" && :>"${S}/deps/.got" && :>"${S}/deps/.built" || die
	gawk -i inplace '
/^{[[:space:]]*deps[[:space:]]*,/, /}[[:space:]]*\.$/ {
	if ($0 ~ /}[[:space:]]*\.$/) {
		print "{deps, []}.";
	}
	next;
}
1
' "${rebar_config}" || die "failed to remove deps from ${rebar_config}"
}

# @FUNCTION: rebar_set_vsn
# @USAGE: [<version>]
# @DESCRIPTION:
# Set version in project description file if it's not set.
#
# <version> is optional. Default is PV stripped from version suffix.
#
# The function dies on failure.
rebar_set_vsn() {
	debug-print-function ${FUNCNAME} "${@}"

	local version="${1:-${PV%_*}}"

	sed -e "s/vsn, git/vsn, \"${version}\"/" \
		-i "${S}/${REBAR_APP_SRC}" \
		|| die "failed to set version in src/${PN}.app.src"
}

# @FUNCTION: rebar_src_prepare
# @DESCRIPTION:
# Prevent rebar from fetching and compiling dependencies. Set version in
# project description file if it's not set.
#
# Existence of rebar.config is optional, but file description file must exist
# at 'src/${PN}.app.src'.
rebar_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	rebar_set_vsn
	if [[ -f rebar.config ]]; then
		rebar_disable_coverage
		rebar_remove_deps
	fi
}

# @FUNCTION: rebar_src_configure
# @DESCRIPTION:
# Configure with ERL_LIBS set.
rebar_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	default
}

# @FUNCTION: rebar_src_compile
# @DESCRIPTION:
# Compile project with rebar.
rebar_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar compile
}

# @FUNCTION: rebar_src_test
# @DESCRIPTION:
# Run unit tests.
rebar_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar eunit
}

# @FUNCTION: rebar_src_install
# @DESCRIPTION:
# Install BEAM files, include headers, executables and native libraries.
# Install standard docs like README or defined in DOCS variable.
#
# Function expects that project conforms to Erlang/OTP structure.
rebar_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local bin
	local dest="$(get_erl_libs)/${P}"

	insinto "${dest}"
	doins -r ebin
	[[ -d include ]] && doins -r include
	[[ -d bin ]] && for bin in bin/*; do dobin "$bin"; done

	if [[ -d priv ]]; then
		cp -pR priv "${ED}${dest}/" || die "failed to install priv/"
	fi

	einstalldocs
}
