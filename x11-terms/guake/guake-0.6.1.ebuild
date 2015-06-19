# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/guake/guake-0.6.1.ebuild,v 1.1 2015/04/25 06:06:43 jer Exp $

EAPI=5

GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 python-single-r1

DESCRIPTION="Drop-down terminal for GTK+ desktops"
HOMEPAGE="https://github.com/Guake/guake"
SRC_URI="https://github.com/${PN^}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-python/dbus-python
	dev-python/gconf-python
	dev-python/notify-python
	dev-python/pygtk
	dev-python/pyxdg
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
