# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A pager dockapp"
HOMEPAGE="https://www.dockapps.net/wmcp"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gcc33.patch
	eapply "${FILESDIR}"/${P}-stdlibh.patch
	sed -i \
		-e "s:gcc:$(tc-getCC):g" \
		-e "s:i686-pc-linux-gnu-gcc -g:i686-pc-linux-gnu-gcc:g" \
		-e "s:i686-pc-linux-gnu-gcc -o:i686-pc-linux-gnu-gcc ${LDFLAGS} -o:" \
		Makefile || die
}

src_compile() {
	emake -j1 INCLUDES="-I/usr/include/X11" \
		LIBINC="-L/usr/$(get_libdir)" \
		FLAGS="${CFLAGS}"
}

src_install() {
	dobin wmcp
	dodoc README
}
