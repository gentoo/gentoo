# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/asmem/asmem-1.12.ebuild,v 1.8 2014/08/10 20:00:53 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="a swallowable applet monitors the utilization level of memory, cache and swap space"
HOMEPAGE="http://www.tigr.net"
SRC_URI="http://www.tigr.net/afterstep/download/asmem/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="jpeg"

RDEPEND="x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXpm
	x11-libs/libXext
	jpeg? ( virtual/jpeg )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_compile() {
	tc-export CC
	econf $(use_enable jpeg)
	emake || die "emake failed."
}

src_install() {
	dobin ${PN}
	newman ${PN}.man ${PN}.1
	dodoc CHANGES README
}
