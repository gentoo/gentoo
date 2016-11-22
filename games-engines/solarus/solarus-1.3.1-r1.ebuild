# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="An open-source Zelda-like 2D game engine"
HOMEPAGE="http://www.solarus-games.org/"
SRC_URI="http://www.zelda-solarus.com/downloads/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc luajit"

RDEPEND="
	dev-games/physfs
	media-libs/libmodplug
	>=media-libs/libsdl2-2.0.1[X,joystick,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png]
	>=media-libs/sdl2-ttf-2.0.12
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_INSTALL_DESTINATION="/usr/bin"
		-DSOLARUS_USE_LUAJIT="$(usex luajit)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		cd doc || die
		doxygen || die
	fi
}

src_install() {
	cmake-utils_src_install
	doman solarus.6
	use doc && dodoc -r doc/${PV%.*}/html/*
}
