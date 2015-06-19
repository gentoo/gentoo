# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmon/wmmon-1.0_beta2-r3.ebuild,v 1.10 2010/08/31 09:48:41 s4t4n Exp $

inherit eutils

S=${WORKDIR}/${PN}.app
IUSE=""
DESCRIPTION="Dockable system resources monitor applet for WindowMaker"
WMMON_VERSION=1_0b2
SRC_URI="http://rpig.dyndns.org/~anstinus/Linux/${PN}-${WMMON_VERSION}.tar.gz"
HOMEPAGE="http://www.bensinclair.com/dockapp/"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"/${PN}
	epatch "${FILESDIR}"/${P}-kernel26-v2.patch
	sed -i -e "s|-O2|${CFLAGS}|" Makefile
	sed -i -e "s|cc -o wmmon|cc ${LDFLAGS} -o wmmon|" Makefile
}

src_compile() {
	emake -C ${PN} || die
}

src_install () {
	dobin wmmon/wmmon
	dodoc BUGS CHANGES HINTS README TODO
}
