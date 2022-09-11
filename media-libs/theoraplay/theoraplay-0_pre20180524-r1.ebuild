# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo multilib toolchain-funcs

COMMIT="7d8701876294"
DESCRIPTION="Simple library to make decoding of Ogg Theora videos easier"
HOMEPAGE="https://icculus.org/projects/theoraplay/"
SRC_URI="https://hg.icculus.org/icculus/${PN}/archive/${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/libtool"

src_compile() {
	edo libtool --tag=CC --mode=compile $(tc-getCC) -shared ${CFLAGS} -pthread -c "${S}"/${PN}.c
	edo libtool --tag=CC --mode=link $(tc-getCC) -shared ${LDFLAGS} -pthread -Wl,-z,defs ${PN}.lo \
			-logg -ltheoradec -lvorbis -o lib${PN}.la -rpath "${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	dolib.so .libs/lib${PN}$(get_libname)*
	doheader ${PN}.h
}
