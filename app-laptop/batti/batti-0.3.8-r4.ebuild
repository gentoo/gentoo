# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils

DESCRIPTION="A upower based battery monitor for the system tray, similar to batterymon"
HOMEPAGE="https://code.google.com/p/batti-gtk/"
SRC_URI="https://batti-gtk.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libnotify"

RDEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	sys-power/upower
	x11-themes/hicolor-icon-theme
	libnotify? ( x11-libs/libnotify )
"
DEPEND=""

src_prepare() {
	default
	if has_version ">=sys-power/upower-0.99"; then
		eapply "${FILESDIR}/${P}-upower-0.99.patch"
		eapply "${FILESDIR}/${P}-upower-capital.patch"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
