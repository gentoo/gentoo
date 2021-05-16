# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal toolchain-funcs

COMMIT="7d8701876294"
DESCRIPTION="Simple library to make decoding of Ogg Theora videos easier"
HOMEPAGE="https://icculus.org/projects/theoraplay/"
SRC_URI="https://hg.icculus.org/icculus/${PN}/archive/${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis
"

S="${WORKDIR}/${PN}-${COMMIT}"

multilib_src_compile() {
	libtool --tag=CC --mode=compile $(tc-getCC) -shared ${CFLAGS} -pthread -c "${S}"/${PN}.c || die
	libtool --tag=CC --mode=link $(tc-getCC) -shared ${LDFLAGS} -pthread -Wl,-z,defs ${PN}.lo \
			-logg -ltheoradec -lvorbis -o lib${PN}.la -rpath "${EPREFIX}/usr/$(get_libdir)" || die
}

multilib_src_install() {
	dolib.so .libs/lib${PN}$(get_libname)*
}

multilib_src_install_all() {
	doheader ${PN}.h
}
