# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnofract4d/gnofract4d-3.14-r1.ebuild,v 1.1 2015/07/15 05:10:00 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://gnofract4d.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
