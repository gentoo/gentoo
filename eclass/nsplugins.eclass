# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: nsplugins.eclass
# @MAINTAINER:
# Mozilla Team <mozilla@gentoo.org>
# @AUTHOR:
# Original Author: Martin Schlemmer <azarah@gentoo.org>
# @BLURB: reusable functions for netscape/moz plugin sharing
# @DESCRIPTION:
# Reusable functions that promote sharing of netscape/moz plugins, also provides
# share_plugins_dir function for mozilla applications.

inherit eutils multilib versionator mozextension

PLUGINS_DIR="nsbrowser/plugins"

# This function move the plugin dir in src_install() to
# ${D}/usr/$(get_libdir)/${PLUGIN_DIR}.  First argument should be
# the full path (without $D) to old plugin dir.
src_mv_plugins() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && ED="${D}"

	# Move plugins dir.  We use keepdir so that it might not be unmerged
	# by mistake ...
	keepdir /usr/$(get_libdir)/${PLUGINS_DIR}
	cp -a "${ED}"/$1/* "${ED}"/usr/$(get_libdir)/${PLUGINS_DIR}
	rm -rf "${ED}"/$1
	dosym /usr/$(get_libdir)/${PLUGINS_DIR} $1
}

# This function move plugins in pkg_preinst() in old dir to
# ${ROOT}/usr/$(get_libdir)/${PLUGIN_DIR}.  First argument should be
# the full path (without $ROOT) to old plugin dir.
pkg_mv_plugins() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && ED="${ROOT}"

	# Move old plugins dir
	if [ -d "${ROOT}/$1" -a ! -L "${ROOT}/$1" ]
	then
		mkdir -p "${EROOT}"/usr/$(get_libdir)/${PLUGINS_DIR}
		cp -a "${EROOT}"/$1/* "${EROOT}"/usr/$(get_libdir)/${PLUGINS_DIR}
		rm -rf "${EROOT}"/$1
	fi
}

# This function installs a plugin with dosym to PLUGINS_DIR.
# First argument should be the plugin file.
inst_plugin() {
	if [[ -z "${1}" ]]; then
		eerror "The plugin file \"${1}\" does not exist."
		die "No such file or directory."
	fi

	dodir /usr/$(get_libdir)/${PLUGINS_DIR}
	dosym ${1} /usr/$(get_libdir)/${PLUGINS_DIR}/$(basename ${1})
}

# This function ensures we use proper plugin path for Gentoo.
# This should only be used by mozilla packages.
# ${MOZILLA_FIVE_HOME} must be defined in src_install to support
share_plugins_dir() {
	if [[ ${PN} == seamonkey ]] ; then
		rm -rf "${D}"${MOZILLA_FIVE_HOME}/plugins \
			|| die "failed to remove existing plugins dir"
	fi

	if [[ ${PN} == *-bin ]] ; then
		PLUGIN_BASE_PATH="/usr/$(get_libdir)"
	else
		PLUGIN_BASE_PATH=".."
	fi

	if $(mozversion_extension_location) ; then
		dosym "${PLUGIN_BASE_PATH}/nsbrowser/plugins" "${MOZILLA_FIVE_HOME}/browser/plugins"
	else
		dosym "${PLUGIN_BASE_PATH}/nsbrowser/plugins" "${MOZILLA_FIVE_HOME}/plugins"
	fi
}
