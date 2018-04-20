# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 xdg-utils

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://gnofract4d.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=media-libs/libpng-1.4
	virtual/jpeg
	>=dev-python/pygtk-2[${PYTHON_USEDEP}]
	>=gnome-base/gconf-2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	distutils-r1_src_install
	rm -rf "${D}"/usr/share/doc/${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
