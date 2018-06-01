# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A 2D top-down action game; escape a facility full of walking death machines"
HOMEPAGE="http://sdb.gamecreation.org/"
SRC_URI="http://gcsociety.sp.cs.cmu.edu/~frenzy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "s:models/:/usr/share/${PN}/models/:" \
		-e "s:snd/:/usr/share/${PN}/snd/:" \
		-e "s:sprites/:/usr/share/${PN}/sprites/:" \
		-e "s:levels/:/usr/share/${PN}/levels/:" \
		src/sdb.h src/game.cpp || die "setting game paths"
	eapply \
		"${FILESDIR}"/${P}-endian.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake \
		-C src \
		CXXFLAGS="${CXXFLAGS} $(sdl-config --cflags)"
}

src_install() {
	dobin src/sdb
	insinto /usr/share/${PN}
	doins -r levels models snd sprites
	newicon sprites/barrel.png ${PN}.png
	make_desktop_entry sdb "Shotgun Debugger"
	einstalldocs
}
