# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils fdo-mime

MY_PV=${PV/%[[:alpha:]]/}

DESCRIPTION="LaTeX editor based on Bluefish"
HOMEPAGE="http://winefish.berlios.de/"
#SRC_URI="mirror://berlios/${PN}/${P}.tgz"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="spell"

RDEPEND=">=x11-libs/gtk+-2.4:2
	>=dev-libs/libpcre-6.3
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-nostrip.patch"
}

src_configure() {
	econf --disable-update-databases
}

src_install() {
	emake install DESTDIR="${D}" docdir=/usr/share/doc/${PF}/html || die "emake install failed"
	dodoc AUTHORS CHANGES README ROADMAP THANKS TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	elog "You need to emerge a TeX distribution to gain winefish's full capacity"
}
