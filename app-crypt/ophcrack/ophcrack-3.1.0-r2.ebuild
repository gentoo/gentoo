# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ophcrack/ophcrack-3.1.0-r2.ebuild,v 1.6 2014/05/14 14:41:26 tomwij Exp $

EAPI="5"
inherit eutils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="qt4 debug"

CDEPEND="dev-libs/openssl
		 net-libs/netwib
		 qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )"
DEPEND="app-arch/unzip
		virtual/pkgconfig
		${CDEPEND}"
RDEPEND="app-crypt/ophcrack-tables
		 ${CDEPEND}"

src_configure() {
	econf $(use_enable qt4 gui) $(use_enable debug)
}

src_install() {
	default

	newicon src/gui/pixmaps/os.xpm ${PN}.xpm
	make_desktop_entry "${PN}" OphCrack ${PN}
}
