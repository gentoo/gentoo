# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Scientific calculator designed to provide maximum usability"
HOMEPAGE="http://calcoo.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gold.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-gtktest
}

src_install() {
	default

	newicon src/pixmaps/main.xpm ${PN}.xpm
	make_desktop_entry ${PN} Calcoo ${PN} "Education;Math"
}
