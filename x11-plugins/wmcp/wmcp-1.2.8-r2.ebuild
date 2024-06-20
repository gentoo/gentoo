# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A pager dockapp"
HOMEPAGE="https://www.dockapps.net/wmcp"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-gcc33.patch
	"${FILESDIR}"/${P}-stdlibh.patch
	)
src_prepare() {
	default
	sed -i \
		-e "s:gcc -g -c:$(tc-getCC) -c:" \
		-e "s:gcc -g -o:$(tc-getCC) ${LDFLAGS} -o:" \
		Makefile || die
}

src_compile() {
	emake INCLUDES="-I/usr/include/X11" \
		LIBINC="-L/usr/$(get_libdir)" \
		FLAGS="${CFLAGS}"
}

src_install() {
	dobin wmcp
	dodoc README
}
