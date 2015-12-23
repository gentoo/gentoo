# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils games

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://supertuxproject.org/"
SRC_URI="https://github.com/SuperTux/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-games/physfs
	dev-libs/boost:=
	media-libs/glew:=
	virtual/opengl
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/libsdl2-2.0.1[joystick,video]
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-{obstack,tinygettext,squirrel,desktop,flags,license,icon}.patch )

src_configure() {
	local mycmakeargs=(
		-DWERROR=OFF
		-DINSTALL_SUBDIR_BIN=games/bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		$(cmake-utils_use_enable debug SQDBG)
		$(cmake-utils_use debug)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
