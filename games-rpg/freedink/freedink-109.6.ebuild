# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Dink Smallwood is an adventure/role-playing game, similar to Zelda (2D top view)"
HOMEPAGE="https://www.gnu.org/s/freedink/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	media-libs/fontconfig
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-gfx
	media-libs/sdl2-image
	media-libs/sdl2-mixer[midi,vorbis,wav]
	media-libs/sdl2-ttf"
RDEPEND="
	${COMMON_DEPEND}
	games-rpg/freedink-data"
DEPEND="
	${COMMON_DEPEND}
	media-libs/glm"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-odr.patch
	"${FILESDIR}"/${P}-sdl.patch
)

src_configure() {
	local econfargs=(
		# TODO? Needs unpackaged cxxtest, but that package (currently) seem
		# dead and may not be worth adding just for testing this.
		--disable-tests

		# Fails if finds a windres executable
		ac_cv_prog_WINDRES=
		ac_cv_prog_ac_ct_WINDRES=
	)

	econf "${econfargs[@]}"
}
