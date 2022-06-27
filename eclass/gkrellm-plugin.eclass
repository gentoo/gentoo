# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gkrellm-plugin.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Jim Ramsay <lack@gentoo.org>
# EAPI 6 author: David Seifert <soap@gentoo.org>
# EAPI 8 author: Thomas Bracht Laumann Jespersen <t@laumann.xyz>
# @SUPPORTED_EAPIS: 6 8
# @PROVIDES: multilib
# @BLURB: Provides src_install used by (almost) all gkrellm plugins
# @DESCRIPTION:
# - Sets up default dependencies
# - Provides a common src_install method to avoid code duplication
#
# Changelog:
#   17 March 2022: Thomas Bracht Laumann Jespersen <t@laumann.xyz>
#     - Port to EAPI 8
#   03 January 2018: David Seifert <soap@gentoo.org>
#     - Port to EAPI 6, remove built_with_use, simplify a lot
#   12 March 2007: Jim Ramsay <lack@gentoo.org>
#     - Added server plugin support
#   09 March 2007: Jim Ramsay <lack@gentoo.org>
#     - Initial commit
#

# @ECLASS_VARIABLE: PLUGIN_SO
# @DESCRIPTION:
# The name of the plugin's .so file which will be installed in
# the plugin dir. Defaults to "${PN}$(get_modname)". Has to be a bash array.

# @ECLASS_VARIABLE: PLUGIN_SERVER_SO
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the plugin's server plugin $(get_modname) portion.
# Unset by default. Has to be a bash array.

# @ECLASS_VARIABLE: PLUGIN_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An optional list of docs to be installed, in addition to the default
# DOCS variable which is respected too. Has to be a bash array.

case ${EAPI} in
	6|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit multilib

if [[ ! ${_GKRELLM_PLUGIN_R1} ]]; then
_GKRELLM_PLUGIN_R1=1

if [[ ${EAPI} == 6 ]]; then
	DEPEND="virtual/pkgconfig"
else
	BDEPEND="virtual/pkgconfig"
fi

# @FUNCTION: gkrellm-plugin_src_install
# @USAGE:
# @DESCRIPTION:
# Install the plugins and call einstalldocs
gkrellm-plugin_src_install() {
	exeinto /usr/$(get_libdir)/gkrellm2/plugins

	if ! declare -p PLUGIN_SO >/dev/null 2>&1 ; then
		doexe ${PN}$(get_modname)
	elif declare -p PLUGIN_SO | grep -q "^declare -a " ; then
		doexe "${PLUGIN_SO[@]}"
	else
		die "PLUGIN_SO has to be a bash array!"
	fi

	if [[ -n ${PLUGIN_SERVER_SO} ]]; then
		exeinto /usr/$(get_libdir)/gkrellm2/plugins-gkrellmd

		if declare -p PLUGIN_SERVER_SO | grep -q "^declare -a " ; then
			doexe "${PLUGIN_SERVER_SO[@]}"
		else
			die "PLUGIN_SERVER_SO has to be a bash array!"
		fi
	fi

	einstalldocs
	local d
	for d in Changelog* ChangeLog*; do
		[[ -s "${d}" ]] && dodoc "${d}"
	done

	if [[ -n ${PLUGIN_DOCS} ]]; then
		if declare -p PLUGIN_DOCS | grep -q "^declare -a " ; then
			dodoc "${PLUGIN_DOCS[@]}"
		else
			die "PLUGIN_DOCS has to be a bash array!"
		fi
	fi
}

fi

EXPORT_FUNCTIONS src_install
