# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libressl qt5 +tables"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/netwib
	qt5? (
		dev-qt/qtcharts:5
		dev-qt/qtgui:5
	)"
RDEPEND="
	${DEPEND}
	tables? ( app-crypt/ophcrack-tables )"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/ophcrack-ar.patch )

src_configure() {
	tc-export AR

	econf \
		$(use_enable debug) \
		$(use_enable qt5 gui)
}

src_install() {
	default

	newicon src/gui/pixmaps/os.xpm ophcrack.xpm
	make_desktop_entry "${PN}" OphCrack ophcrack
}
