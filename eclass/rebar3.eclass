# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rebar3.eclass
# @MAINTAINER:
# Florian Schmaus <flow@gentoo.org>
# @AUTHOR:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# Anna (cybertailor) Vyalkova <cyber+gentoo@sysrq.in>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: rebar-utils
# @BLURB: Build Erlang/OTP projects using dev-util/rebar:3.
# @DESCRIPTION:
# An eclass providing functions to build Erlang/OTP projects using
# dev-util/rebar:3.
#
# rebar is a tool which tries to resolve dependencies itself which is by
# cloning remote git repositories. Dependent projects are usually expected to
# be in sub-directory 'deps' rather than looking at system Erlang lib
# directory. Projects relying on rebar usually don't have 'install' make
# targets. The eclass workarounds some of these problems. It handles
# installation in a generic way for Erlang/OTP structured projects.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_REBAR3_ECLASS} ]]; then
_REBAR3_ECLASS=1

inherit edo rebar-utils

RDEPEND="dev-lang/erlang:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/rebar:3
	>=sys-apps/gawk-4.1
"

# @ECLASS_VARIABLE: REBAR_PROFILE
# @DESCRIPTION:
# Rebar profile to use. Defaults to
# 'default'.
: "${REBAR_PROFILE:=default}"

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

# @FUNCTION: erebar3
# @USAGE: <targets>
# @DESCRIPTION:
# Run rebar with verbose flag. Die on failure.
erebar3() {
	debug-print-function ${FUNCNAME} "${@}"

	(( $# > 0 )) || die "${FUNCNAME}: at least one target is required"

	case ${1} in
		eunit|ct)
			local -x ERL_LIBS="." ;;
		*)
			local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)" ;;
	esac

	local -x HEX_OFFLINE=true
	edo rebar3 "$@"
}

# @FUNCTION: rebar3_src_prepare
# @DESCRIPTION:
# Prevent rebar3 from fetching and compiling dependencies. Set version in
# project description file if it's not set.
#
# Existence of rebar.config is optional, but file description file must exist
# at 'src/${PN}.app.src'.
rebar3_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	rebar_set_vsn

	if [[ -f rebar.lock ]]; then
		rm rebar.lock || die
	fi

	if [[ -f rebar.config ]]; then
		rebar_disable_coverage
		rebar_remove_deps
	fi
}

# @FUNCTION: rebar3_src_configure
# @DESCRIPTION:
# Configure with ERL_LIBS set.
rebar3_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	default
}

# @FUNCTION: rebar3_src_compile
# @DESCRIPTION:
# Compile project with rebar3.
rebar3_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar3 as "${REBAR_PROFILE}" release --all
}

# @FUNCTION: rebar3_src_test
# @DESCRIPTION:
# Run unit tests.
rebar3_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar3 eunit -v
}

# @FUNCTION: rebar3_install_lib
# @USAGE: <dir>
# @DESCRIPTION:
# Install BEAM files, include headers and native libraries.
#
# Function expects that project conforms to Erlang/OTP structure.
rebar3_install_lib() {
	debug-print-function ${FUNCNAME} "${@}"

	local dest="$(get_erl_libs)/${P}"
	insinto "${dest}"

	pushd "${1?}" >/dev/null || die
	for dir in ebin include priv; do
		if [[ -d ${dir} && ! -L ${dir} ]]; then
			doins -r "${dir}"
		fi
	done
	popd >/dev/null || die
}

# @FUNCTION: rebar3_src_install
# @DESCRIPTION:
# Install built release or library.
#
# Function expects that project conforms to Erlang/OTP structure.
rebar3_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	pushd "_build/${REBAR_PROFILE}" >/dev/null || die
	if [[ -d rel/${PN} ]]; then
		if ! declare -f rebar3_install_release >/dev/null; then
			die "${FUNCNAME}: a custom function named 'rebar3_install_release' is required to install a release"
		fi
		pushd rel/${PN} >/dev/null || die
		rebar3_install_release || die
		popd >/dev/null || die
	elif [[ -d lib/${PN} ]]; then
		rebar3_install_lib lib/${PN}
	else
		die "No releases or libraries to install"
	fi
	popd >/dev/null || die

	einstalldocs
}

fi

EXPORT_FUNCTIONS src_prepare src_compile src_test src_install
