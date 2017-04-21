# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools git-r3 gnome2 python-single-r1

DESCRIPTION="Drop-down terminal for GTK+ desktops"
HOMEPAGE="https://github.com/Guake/guake"
# override gnome.org.eclass SRC_URI
SRC_URI=''
EGIT_REPO_URI="https://github.com/Guake/guake.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
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

src_unpack() {
	# override gnome2_src_unpack()
	git-r3_src_unpack
}

src_prepare() {
	default

	eautoreconf

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
