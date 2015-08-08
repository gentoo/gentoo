# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

DESCRIPTION="A pager dockapp"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/158"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/213/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc33.patch
	epatch "${FILESDIR}"/${P}-stdlibh.patch
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile
	sed -i -e "s:i686-pc-linux-gnu-gcc -g:i686-pc-linux-gnu-gcc:g" Makefile
	sed -i -e "s:i686-pc-linux-gnu-gcc -o:i686-pc-linux-gnu-gcc ${LDFLAGS} -o:" Makefile
}

src_compile() {
	emake -j1 INCLUDES="-I/usr/include/X11" \
		LIBINC="-L/usr/$(get_libdir)" \
		FLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmcp
	dodoc README
}
