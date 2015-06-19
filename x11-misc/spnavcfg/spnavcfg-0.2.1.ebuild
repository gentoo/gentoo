# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/spnavcfg/spnavcfg-0.2.1.ebuild,v 1.2 2012/05/05 04:53:42 jdhore Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="GTK-based GUI to configure a space navigator device"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/spacenav/spacenavd%20config%20gui/${PN}%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	app-misc/spacenavd[X]"

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-custom-flags.patch
	epatch "${FILESDIR}"/${P}-x11-libs.patch
}

src_compile() {
	emake CC=$(tc-getCC) || die "Make failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README || die
}
