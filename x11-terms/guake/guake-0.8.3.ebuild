# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1

DESCRIPTION="Drop-down terminal for GTK+ desktops"
HOMEPAGE="https://github.com/Guake/guake"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/keybinder:0[python,${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/vte:0[python]
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README.rst )

src_prepare() {
	eautoreconf

	gnome2_src_prepare

	G2CONF="--disable-static"
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
