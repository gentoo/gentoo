# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="SDL app to test joysticks and game controllers"
HOMEPAGE="http://sdljoytest.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdljoytest/SDLJoytest-GL-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[joystick,opengl,video]
	virtual/opengl
	media-libs/sdl-image"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SDLJoytest-GL

PATCHES=("${FILESDIR}"/${P}-no-common.patch)

src_prepare() {
	default
	emake clean
	sed -i -e 's:/usr/local:/usr:' joytest.h || die
	sed -i -e 's:SDL/::' *.c || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="$(sdl-config --cflags) ${CFLAGS}" \
		LDFLAGS="$(sdl-config --libs) -lGL ${LDFLAGS}"
}

src_install() {
	dobin SDLJoytest-GL
	insinto /usr/share/SDLJoytest-GL
	doins *.bmp
	doman SDLJoytest.1
}
