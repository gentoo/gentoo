# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmdl/wmdl-1.4.1.ebuild,v 1.18 2010/09/20 09:08:04 s4t4n Exp $

inherit eutils

IUSE=""
DESCRIPTION="WindowMaker Doom Load dockapp"
HOMEPAGE="http://the.homepage.doesnt.appear.to.exist.anymore.com"
SRC_URI="http://www.ibiblio.org/pub/linux/distributions/gentoo/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/makefile.diff

}

src_compile() {
	emake FLAGS="${CFLAGS} ${LDFLAGS}" || die "parallel make failed"
}

src_install() {
	dobin wmdl || die "dobin failed."
}
