# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils games

MY_P=ValyriaTear-${PV/_rc/-rc}

DESCRIPTION="A free 2D J-RPG based on the Hero of Allacrost engine"
HOMEPAGE="http://valyriatear.blogspot.de/
	https://github.com/Bertram25/ValyriaTear"
SRC_URI="https://github.com/Bertram25/ValyriaTear/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+ GPL-3 CC-BY-SA-3.0 CC-BY-3.0 CC0-1.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug editor nls"

RDEPEND="
	dev-cpp/luabind
	dev-lang/lua:0
	media-libs/libpng:0=
	media-libs/libsdl[X,joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	editor? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-libs/boost
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_LUABIND=ON
		-DPKG_BINDIR="${GAMES_BINDIR}"
		-DPKG_DATADIR="${GAMES_DATADIR}/${PN}"
		$(cmake-utils_use editor EDITOR_SUPPORT)
		$(cmake-utils_use !nls DISABLE_TRANSLATIONS)
		$(cmake-utils_use debug DEBUG_FEATURES)
		-DUSE_PCH_COMPILATION=OFF
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
