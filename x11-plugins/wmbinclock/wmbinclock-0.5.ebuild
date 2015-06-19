# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbinclock/wmbinclock-0.5.ebuild,v 1.7 2014/08/10 20:04:44 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="a nifty little binary clock dockapp"
HOMEPAGE="http://wmbinclock.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		INCDIR="-I/usr/include/X11" LIBDIR="" \
		SYSTEM="${LDFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmBinClock
	dosym wmBinClock /usr/bin/${PN}
	dodoc CHANGELOG README
}
