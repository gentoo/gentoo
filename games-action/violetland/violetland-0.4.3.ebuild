# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs flag-o-matic cmake-utils games

DESCRIPTION="Help a girl by name of Violet to struggle with hordes of monsters"
HOMEPAGE="https://code.google.com/p/violetland/"
SRC_URI="https://github.com/ooxi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	dev-libs/boost[threads(+)]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "/README_EN.TXT/d" \
		-e "/README_RU.TXT/d" \
		CMakeLists.txt || die "sed failed"
	epatch "${FILESDIR}"/${P}-boost150.patch
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATA_INSTALL_DIR=${GAMES_DATADIR}/${PN}"
		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS="README_EN.TXT CHANGELOG" cmake-utils_src_install
	newicon icon-light.png ${PN}.png
	make_desktop_entry ${PN} VioletLand
	prepgamesdirs
}
