# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib toolchain-funcs

DESCRIPTION="Fake library to override default libXinerama and expose custom screen dimensions"
HOMEPAGE="https://github.com/Xpra-org/libfakeXinerama"
SRC_URI="https://xpra.org/src/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	x11-libs/libX11
	x11-libs/libXinerama
"

src_compile() {
	libtool --tag=CC --mode=compile $(tc-getCC) -shared ${CFLAGS} -c ${PN#lib}.c || die
	libtool --tag=CC --mode=link $(tc-getCC) -shared ${LDFLAGS} -Wl,-z,defs ${PN#lib}.lo \
			-o ${PN}.la -rpath "${EPREFIX}/usr/$(get_libdir)" -version-number 1:0:0 || die
}

src_install() {
	dolib.so .libs/${PN}$(get_libname)*
	dodoc README.TXT
}
