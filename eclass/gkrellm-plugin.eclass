# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: Jim Ramsay <lack@gentoo.org>
#
# Purpose:
#   Provides common methods used by (almost) all gkrellm plugins:
#    - Sets up default dependencies
#    - Adds pkg_setup check to ensure gkrellm was built with USE="X" (bug
#      167227)
#    - Provides utility routines in lieu of hard-coding the plugin directories.
#    - Provides the most common src_install method to avoid code duplication.
#
# Utility Routines:
#   gkrellm-plugin_dir - Returns the gkrellm-2 plugin directory
#   gkrellm-plugin_server_dir - Returns the gkrellm-2 server plugin directory
#
# Environment:
#   For src_install:
#     PLUGIN_SO - The name of the plugin's .so file which will be installed in
#       the plugin dir.  Defaults to "${PN}.so".
#     PLUGIN_DOCS - An optional list of docs to be installed.  Defaults to
#       unset.
#     PLUGIN_SERVER_SO - The name of the plugin's server plugin .so portion.
#       Defaults to unset.
#       Important: This will also cause the pkg_setup check to be skipped, so
#       you need to check 'build_with_use app-admin/gkrellm X' in your
#       src_compile and only compile the GUI portion if that returns true.  (see
#       x11-plugins/gkrelltop as an example)
#
# Changelog:
#   12 March 2007: Jim Ramsay <lack@gentoo.org>
#     - Added server plugin support
#   09 March 2007: Jim Ramsay <lack@gentoo.org>
#     - Initial commit
#

inherit multilib eutils

RDEPEND="=app-admin/gkrellm-2*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

gkrellm-plugin_dir() {
	echo /usr/$(get_libdir)/gkrellm2/plugins
}

gkrellm-plugin_server_dir() {
	echo /usr/$(get_libdir)/gkrellm2/plugins-gkrellmd
}

gkrellm-plugin_pkg_setup() {
	if [[ -z "${PLUGIN_SERVER_SO}" ]] &&
		! built_with_use app-admin/gkrellm X; then
		eerror "This plugin requires the X frontend of gkrellm."
		eerror "Please re-emerge app-admin/gkrellm with USE=\"X\""
		die "Please re-emerge app-admin/gkrellm with USE=\"X\""
	fi
}

gkrellm-plugin_src_install() {
	if built_with_use app-admin/gkrellm X; then
		insinto $(gkrellm-plugin_dir)
		doins ${PLUGIN_SO:-${PN}.so} || die "Plugin shared library was not installed"
	fi

	if [[ -n "${PLUGIN_SERVER_SO}" ]]; then
		insinto $(gkrellm-plugin_server_dir)
		doins ${PLUGIN_SERVER_SO} || die "Server plugin shared library was not installed"
	fi

	DDOCS="README* Change* AUTHORS FAQ TODO INSTALL"

	for doc in ${DDOCS}; do
		[ -s "$doc" ] && dodoc $doc
	done

	[ -n "${PLUGIN_DOCS}" ] && dodoc ${PLUGIN_DOCS}
}

EXPORT_FUNCTIONS pkg_setup src_install
