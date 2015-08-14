# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gnome-games.eclass
# @MAINTAINER:
# Gnome team <gnome@gentoo.org>
# @AUTHOR:
# Author: Pacho Ramos <pacho@gentoo.org>
# @BLURB: An eclass to build gnome-games.
# @DESCRIPTION:
# An eclass to build gnome-games using proper phases from gnome2 and
# games eclasses.

case "${EAPI:-0}" in
	0|1)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	2|3|4|5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

inherit autotools games gnome2

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm

if [[ ! ${_GNOME_GAMES} ]]; then

DEPEND=">=dev-util/intltool-0.50.2-r1"
RDEPEND="!gnome-extra/gnome-games"

# @FUNCTION: gnome-games_pkg_setup
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"
	games_pkg_setup
}

# @FUNCTION: gnome-games_src_prepare
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	# Fix intltoolize broken file:
	# https://bugs.launchpad.net/intltool/+bug/398571
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	gnome2_src_prepare
}

# @FUNCTION: gnome-games_src_configure
# @DESCRIPTION:
# Set proper phase defaults, relying on gnome2_src_configure
# and passing extra arguments from egamesconf (games.eclass)
gnome-games_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_src_configure \
		--prefix="${GAMES_PREFIX}" \
		--libdir="$(games_get_libdir)" \
		--sysconfdir="${GAMES_SYSCONFDIR}" \
		--localstatedir=/var \
		--localedir=/usr/share/locale \
		"$@"
}

# @FUNCTION: gnome-games_src_compile
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_src_compile
}

# @FUNCTION: gnome-games_src_install
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_src_install() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_src_install
	prepgamesdirs
}

# @FUNCTION: gnome-games_pkg_preinst
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_pkg_preinst
	games_pkg_preinst
}

# @FUNCTION: gnome-games_pkg_postinst
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_pkg_postinst
	games_pkg_postinst
}

# @FUNCTION: gnome-games_pkg_postrm
# @DESCRIPTION:
# Set proper phase defaults
gnome-games_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"
	gnome2_pkg_postrm
}

_GNOME_GAMES=1
fi
