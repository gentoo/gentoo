# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rebar-utils.eclass
# @MAINTAINER:
# Florian Schmaus <flow@gentoo.org>
# @AUTHOR:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Auxiliary functions for using dev-util/rebar.
# @DESCRIPTION:
# This eclass provides a set of axiliary functions commonly needed
# when building Erlang/OTP packages with rebar.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_REBAR_UTILS_ECLASS} ]]; then
_REBAR_UTILS_ECLASS=1

# @ECLASS_VARIABLE: REBAR_APP_SRC
# @DESCRIPTION:
# Relative path to .app.src description file. Defaults to
# 'src/${PN}.app.src'.
: "${REBAR_APP_SRC:=src/${PN}.app.src}"

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

# @FUNCTION: rebar_fix_include_path
# @USAGE: <project_name> [<rebar_config>]
# @DESCRIPTION:
# Fix path in rebar.config to 'include' directory of dependent project/package,
# so it points to installation in system Erlang lib rather than relative 'deps'
# directory.
#
# <rebar_config> is optional. Default is 'rebar.config'.
#
# The function dies on failure.
rebar_fix_include_path() {
	debug-print-function ${FUNCNAME} "${@}"

	local pn="${1}"
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

fi
