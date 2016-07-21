# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit python distutils gnome2-utils eutils

DESCRIPTION="A upower based battery monitor for the system tray, similar to batterymon"
HOMEPAGE="https://code.google.com/p/batti-gtk/"
SRC_URI="https://batti-gtk.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libnotify"

RDEPEND="dev-python/pygtk
	dev-python/dbus-python
	|| ( sys-power/upower sys-power/upower-pm-utils )
	x11-themes/gnome-icon-theme
	libnotify? ( x11-libs/libnotify )"
DEPEND=""

DOCS="AUTHORS"

src_prepare() {
	has_version ">=sys-power/upower-0.99" && epatch "${FILESDIR}/${P}-upower-0.99.patch"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	distutils_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	distutils_pkg_postrm
}
