# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit toolchain-funcs

DESCRIPTION="a dockapp that displays time and date (same style as NEXTSTEP(tm) operating systems)"
SRC_URI="http://www.bluestop.org/wmclock/${P}.tar.gz"
HOMEPAGE="http://www.bluestop.org/wmclock/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-misc/gccmakedep
	x11-misc/imake"

src_compile() {
	emake CC=$(tc-getCC) CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}" || die "make failed"
}

src_install() {
	dobin wmclock || die "dobin failed"
	newman wmclock.man wmclock.1
	dodoc ChangeLog README
}
