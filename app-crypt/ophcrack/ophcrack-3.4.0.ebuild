# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ophcrack/ophcrack-3.4.0.ebuild,v 1.2 2013/03/02 19:14:54 hwoarang Exp $

EAPI="3"
inherit eutils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="qt4 debug +tables"

CDEPEND="dev-libs/openssl
		 net-libs/netwib
		 qt4? ( dev-qt/qtgui:4 )"
DEPEND="app-arch/unzip
		virtual/pkgconfig
		${CDEPEND}"
RDEPEND="tables? ( app-crypt/ophcrack-tables )
		 ${CDEPEND}"

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
