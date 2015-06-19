# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/allin1/allin1-0.5.0-r1.ebuild,v 1.1 2012/10/24 11:25:47 ago Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="All in one monitoring dockapp: RAM, CPU, Net, Power, df, seti"
HOMEPAGE="http://ilpettegolo.altervista.org/linux_allin1.en.shtml"
SRC_URI="mirror://sourceforge/allinone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}/makefile.patch"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/allin1
	doman docs/allin1.1
	dodoc README README.it TODO ChangeLog BUGS src/allin1.conf.example
}
