# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug libressl qt4 +tables"

CDEPEND="!libressl? ( dev-libs/openssl:0= )
		 libressl? ( dev-libs/libressl:0= )
		 net-libs/netwib
		 qt4? ( dev-qt/qtgui:4 )"
DEPEND="app-arch/unzip
		virtual/pkgconfig
		${CDEPEND}"
RDEPEND="tables? ( app-crypt/ophcrack-tables )
		 ${CDEPEND}"

PATCHES="${FILESDIR}/ophcrack-openssl-des.patch"

src_configure() {

	local myconf

	myconf="$(use_enable qt4 gui)"
	myconf="${myconf} $(use_enable debug)"

	econf ${myconf} || die "Failed to compile"
}

src_install() {
	emake install DESTDIR="${D}" || die "Installation failed."

	cd "${S}"
	newicon src/gui/pixmaps/os.xpm ophcrack.xpm
	make_desktop_entry "${PN}" OphCrack ophcrack
}
