# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rebar.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: rebar-utils
# @BLURB: Build Erlang/OTP projects using dev-util/rebar.
# @DESCRIPTION:
# An eclass providing functions to build Erlang/OTP projects using
# dev-util/rebar.
#
# rebar is a tool which tries to resolve dependencies itself which is by
# cloning remote git repositories. Dependent projects are usually expected to
# be in sub-directory 'deps' rather than looking at system Erlang lib
# directory. Projects relying on rebar usually don't have 'install' make
# targets. The eclass workarounds some of these problems. It handles
# installation in a generic way for Erlang/OTP structured projects.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_REBAR_ECLASS} ]]; then
_REBAR_ECLASS=1

inherit rebar-utils

RDEPEND="dev-lang/erlang:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/rebar:0
	>=sys-apps/gawk-4.1
"

# @FUNCTION: _rebar_find_dep
# @INTERNAL
# @USAGE: <project_name>
# @RETURN: 0 success, 1 dependency not found, 2 multiple versions found
# @DESCRIPTION:
# Find a Erlang package/project by name in Erlang lib directory. Project
# directory is usually suffixed with version. It is matched to '<project_name>'
# or '<project_name>-*'.
_rebar_find_dep() {
	local pn="${1}"
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

# @FUNCTION: erebar
# @USAGE: <targets>
# @DESCRIPTION:
# Run rebar with verbose flag. Die on failure.
erebar() {
	debug-print-function ${FUNCNAME} "$@"

	(( $# > 0 )) || die "erebar: at least one target is required"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	[[ ${1} == eunit ]] && local -x ERL_LIBS="."

	rebar -v skip_deps=true "$@" || die -n "rebar $@ failed"
}

# @FUNCTION: rebar_src_prepare
# @DESCRIPTION:
# Prevent rebar from fetching and compiling dependencies. Set version in
# project description file if it's not set.
#
# Existence of rebar.config is optional, but file description file must exist
# at 'src/${PN}.app.src'.
rebar_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

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
	debug-print-function ${FUNCNAME} "$@"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	default
}

# @FUNCTION: rebar_src_compile
# @DESCRIPTION:
# Compile project with rebar.
rebar_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	erebar compile
}

# @FUNCTION: rebar_src_test
# @DESCRIPTION:
# Run unit tests.
rebar_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	erebar eunit
}

# @FUNCTION: rebar_src_install
# @DESCRIPTION:
# Install BEAM files, include headers, executables and native libraries.
# Install standard docs like README or defined in DOCS variable.
#
# Function expects that project conforms to Erlang/OTP structure.
rebar_src_install() {
	debug-print-function ${FUNCNAME} "$@"

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

fi

EXPORT_FUNCTIONS src_prepare src_compile src_test src_install
