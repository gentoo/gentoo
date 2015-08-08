# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="a blue dockapp to monitor CPU usage"
HOMEPAGE="http://misuceldestept.go.ro/wmbluecpu"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	sed -e 's:$(CC) -o:$(CC) $(LDFLAGS) -o:' -e 's:-L/usr/X11R6/lib::' \
		-e 's:strip $(PROG)::' -i "${S}"/Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		|| die "emake failed."
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc AUTHORS ChangeLog README THANKS
}
