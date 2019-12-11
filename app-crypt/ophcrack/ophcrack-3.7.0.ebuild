# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils

DESCRIPTION="A time-memory-trade-off-cracker"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug libressl +tables"

CDEPEND="!libressl? ( dev-libs/openssl:0= )
		 libressl? ( dev-libs/libressl:0= )
		 net-libs/netwib"
DEPEND="app-arch/unzip
		 virtual/pkgconfig
		 ${CDEPEND}"
RDEPEND="tables? ( app-crypt/ophcrack-tables )
		 ${CDEPEND}"

src_configure() {

	local myconf

	myconf="${myconf} $(use_enable debug) --disable-gui"

	econf ${myconf}
}

src_install() {
	emake install DESTDIR="${D}"
}
