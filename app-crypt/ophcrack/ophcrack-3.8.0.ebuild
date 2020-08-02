# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libressl qt5 +tables"

CDEPEND="!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		net-libs/netwib
		qt5? ( dev-qt/qtcharts:5
		dev-qt/qtgui:5 )"
DEPEND="app-arch/unzip
		virtual/pkgconfig
		${CDEPEND}"
RDEPEND="tables? ( app-crypt/ophcrack-tables )
		${CDEPEND}"
PATCHES=("${FILESDIR}/ophcrack-ar.patch")

src_configure() {

	local myconf

	myconf="$(use_enable debug)"
	myconf="${myconf} $(use_enable qt5 gui)"

	econf ${myconf}
}

src_install() {
	emake install DESTDIR="${D}"

	cd "${S}"
	newicon src/gui/pixmaps/os.xpm ophcrack.xpm
	make_desktop_entry "${PN}" OphCrack ophcrack
}
