# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils games

MY_P="CorsixTH-${PV}-Source"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="https://code.google.com/p/corsix-th/"
SRC_URI="https://corsix-th.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg truetype opengl +sdl +sound +midi"
REQUIRED_USE="|| ( sdl opengl )"

RDEPEND=">=dev-lang/lua-5.1
	media-libs/libsdl[X]
	ffmpeg? ( virtual/ffmpeg )
	truetype? ( media-libs/freetype:2 )
	opengl? ( virtual/opengl )
	sound? ( media-libs/sdl-mixer )
	midi? ( media-libs/sdl-mixer[timidity] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-nodoc.patch"

	# Use a coherent naming for installation dir
	epatch "${FILESDIR}/${P}-naming.patch"
}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with opengl OPENGL) \
		$(cmake-utils_use_with sdl SDL) \
		$(cmake-utils_use_with sound AUDIO) \
		$(cmake-utils_use_with truetype FREETYPE2) \
		$(cmake-utils_use_with ffmpeg MOVIES) \
		-DCMAKE_INSTALL_PREFIX=${GAMES_DATADIR}"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	DOCS="CorsixTH/README.txt CorsixTH/changelog.txt" cmake-utils_src_install
	games_make_wrapper ${PN} "${GAMES_DATADIR}/${PN}/CorsixTH" || die
	make_desktop_entry ${PN} ${PN} \
		"${GAMES_DATADIR}/${PN}/CorsixTH.ico"
	prepgamesdirs
}
