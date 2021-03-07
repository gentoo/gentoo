# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fast paced action game"
HOMEPAGE="https://icculus.org/excido/"
SRC_URI="https://icculus.org/excido/${P}-src.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-games/physfs
	media-libs/libsdl[opengl]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-libs/openal
	media-libs/freealut"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-freealut.patch
	"${FILESDIR}"/${P}-build.patch
)

src_compile() {
	emake DATADIR=/usr/share/${PN}/
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins data/*
	dodoc BUGS CHANGELOG HACKING README TODO \
		keyguide.txt data/CREDITS data/*.txt
}
