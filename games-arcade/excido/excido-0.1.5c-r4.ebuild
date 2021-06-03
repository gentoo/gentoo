# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Fast paced action game"
HOMEPAGE="https://icculus.org/excido/"
SRC_URI="https://icculus.org/excido/${P}-src.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-games/physfs
	media-libs/freealut
	media-libs/libsdl[opengl]
	media-libs/openal
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-freealut.patch
	"${FILESDIR}"/${P}-build.patch
)

src_compile() {
	tc-export CXX

	emake DATADIR=/usr/share/${PN}/
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data/.

	dodoc BUGS CHANGELOG HACKING README TODO \
		data/{CREDITS,readme-jf-nebula_sky.txt} keyguide.txt

	make_desktop_entry ${PN} Excido applications-games "Game;ArcadeGame"
}
