# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Grumbel/${PN}.git"
else
	HASH_GAMECONTROLLERDB="69c2ca071ac380569b7037e05d9153a08e2e7651"
	SRC_URI="
		https://github.com/Grumbel/${PN}/archive/v${PV}/${P}.tar.gz
		https://github.com/gabomdq/SDL_GameControllerDB/archive/${HASH_GAMECONTROLLERDB}.tar.gz
			-> ${PN}-sdl_gamecontrollerdb-${HASH_GAMECONTROLLERDB::10}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Simple SDL joystick test application for the console"
HOMEPAGE="https://github.com/Grumbel/sdl-jstest"

LICENSE="GPL-3+ ZLIB"
SLOT="0"
IUSE="+sdl sdl1 test"
REQUIRED_USE="|| ( sdl sdl1 )"
RESTRICT="!test? ( test )"

DEPEND="
	sdl1? ( media-libs/libsdl[joystick] )
	sdl? ( media-libs/libsdl2[haptic,joystick] )
	sys-libs/ncurses:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-libs/appstream-glib )
	dev-util/tinycmmc
	virtual/pkgconfig
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		local EGIT_SUBMODULES=( external/sdl_gamecontrollerdb )

		git-r3_src_unpack
	else
		default

		rmdir "${S}"/external/sdl_gamecontrollerdb || die
		mv SDL_GameControllerDB-${HASH_GAMECONTROLLERDB} \
			"${S}"/external/sdl_gamecontrollerdb || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SDL2_JSTEST=$(usex sdl)
		-DBUILD_SDL_JSTEST=$(usex sdl1)
		-DBUILD_TESTS=$(usex test)
		-DWARNINGS=ON
	)

	cmake_src_configure
}
