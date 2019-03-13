# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils scons-utils

DESCRIPTION="Futuristic real-time strategy game"
HOMEPAGE="https://www.boswars.org"
SRC_URI="https://www.boswars.org/dist/releases/${P}-src.tar.gz
	https://dev.gentoo.org/~hasufell/distfiles/${P}-fixed-images-for-libpng-1.6.tar.xz
	mirror://gentoo/bos.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua:0
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libsdl[opengl,sound,video]
	media-libs/libtheora
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-src

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-scons-blows.patch
)

src_unpack() {
	default
	# bug 475764
	cp -dRp ${P}-fixed-images-for-libpng-1.6/* ${P}-src/ \
		|| die "copying fixed images failed!"
}

src_prepare() {
	default

	rm -f doc/{README-SDL.txt,guichan-copyright.txt} || die

	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		engine/include/stratagus.h \
		|| die
	sed -i \
		-e "/-O2/s:-O2.*math:${CXXFLAGS} -Wall:" \
		SConstruct \
		|| die
}

src_compile() {
	escons || die
}

src_install() {
	newbin build/${PN}-release ${PN}
	insinto /usr/share/${PN}
	doins -r campaigns graphics intro languages maps patches scripts sounds units
	newicon "${DISTDIR}"/bos.png ${PN}.png
	make_desktop_entry ${PN} "Bos Wars"
	# COPYRIGHT.txt is referenced by the html
	dodoc CHANGELOG COPYRIGHT.txt README.txt
	dodoc -r doc/*
}
