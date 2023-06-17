# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gkrellm-plugin.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Jim Ramsay <lack@gentoo.org>
# EAPI 6 author: David Seifert <soap@gentoo.org>
# EAPI 8 author: Thomas Bracht Laumann Jespersen <t@laumann.xyz>
# @SUPPORTED_EAPIS: 8
# @BLURB: Provides src_install used by (almost) all gkrellm plugins
# @DESCRIPTION:
# - Sets up default dependencies
# - Provides a common src_install method to avoid code duplication

# @ECLASS_VARIABLE: PLUGIN_SO
# @DESCRIPTION:
# The name of the plugin's .so file which will be installed in
# the plugin dir.  Defaults to "${PN}$(get_modname)".  Has to be a bash array.

# @ECLASS_VARIABLE: PLUGIN_SERVER_SO
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the plugin's server plugin $(get_modname) portion.
# Unset by default.  Has to be a bash array.

# @ECLASS_VARIABLE: PLUGIN_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An optional list of docs to be installed, in addition to the default
# DOCS variable which is respected too.  Has to be a bash array.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_GKRELLM_PLUGIN_ECLASS} ]]; then
_GKRELLM_PLUGIN_ECLASS=1

inherit multilib

BDEPEND="virtual/pkgconfig"

# @FUNCTION: gkrellm-plugin_src_install
# @USAGE:
# @DESCRIPTION:
# Install the plugins and call einstalldocs
gkrellm-plugin_src_install() {
	exeinto /usr/$(get_libdir)/gkrellm2/plugins

	if ! declare -p PLUGIN_SO >/dev/null 2>&1 ; then
		doexe ${PN}$(get_modname)
	else
		doexe "${PLUGIN_SO[@]}"
	fi

	if [[ -n ${PLUGIN_SERVER_SO} ]]; then
		exeinto /usr/$(get_libdir)/gkrellm2/plugins-gkrellmd
		doexe "${PLUGIN_SERVER_SO[@]}"
	fi

	einstalldocs
	local d
	for d in Changelog* ChangeLog*; do
		[[ -s "${d}" ]] && dodoc "${d}"
	done

	[[ -n ${PLUGIN_DOCS} ]] && dodoc "${PLUGIN_DOCS[@]}"
}

fi

EXPORT_FUNCTIONS src_install
