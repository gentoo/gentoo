# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single

DESCRIPTION="An open-source Zelda-like 2D game engine"
HOMEPAGE="https://www.solarus-games.org/"
SRC_URI="http://www.zelda-solarus.com/downloads/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-games/physfs
	media-libs/libmodplug
	>=media-libs/libsdl2-2.0.1[X,joystick,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png]
	>=media-libs/sdl2-ttf-2.0.12"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_INSTALL_DESTINATION="/usr/bin"
		-DSOLARUS_USE_LUAJIT="$(usex lua_single_target_luajit)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc ; then
		cd doc || die
		doxygen || die
	fi
}

src_install() {
	cmake_src_install
	doman solarus.6
	use doc && dodoc -r doc/${PV%.*}/html/*
}
