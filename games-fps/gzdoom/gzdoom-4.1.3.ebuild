# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg

DESCRIPTION="A modder-friendly OpenGL source port based on the DOOM engine"
HOMEPAGE="https://zdoom.org"
SRC_URI="https://github.com/coelckers/${PN}/archive/g${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BZIP2 DUMB-0.9.3 GPL-3 LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk2 openmp"

DEPEND="
	media-libs/libsdl2[opengl]
	media-libs/libsndfile
	media-libs/openal
	media-sound/fluidsynth:=
	media-sound/mpg123
	sys-libs/zlib
	virtual/jpeg:0
	gtk? (
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3 )
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-g${PV}"
PATCHES=(
	"${FILESDIR}/${P}-fluidsynth2.patch"
	"${FILESDIR}/${P}-install_soundfonts.patch"
)

src_prepare() {
	rm -rf docs/licenses || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS_PATH="${EPREFIX}/usr/share/doc/${PF}"
		-DINSTALL_PK3_PATH="${EPREFIX}/usr/share/doom"
		-DINSTALL_SOUNDFONT_PATH="${EPREFIX}/usr/share/doom"
		-DDYN_FLUIDSYNTH=OFF
		-DDYN_OPENAL=OFF
		-DDYN_SNDFILE=OFF
		-DDYN_MPG123=OFF
		-DNO_GTK="$(usex !gtk)"
		-DNO_OPENAL=OFF
		-DNO_OPENMP="$(usex !openmp)"
	)
	cmake-utils_src_configure
}

src_install() {
	newicon src/posix/zdoom.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "GZDoom" "${PN}" "Game;ActionGame"
	cmake-utils_src_install
}
