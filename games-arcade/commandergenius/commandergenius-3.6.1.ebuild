# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

MY_P=Commander-Genius-v${PV}

DESCRIPTION="Open Source Commander Keen clone (needs original game files)"
HOMEPAGE="https://clonekeenplus.sourceforge.io/"
SRC_URI="https://gitlab.com/Dringgstein/Commander-Genius/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+downloader opengl"
RESTRICT="mirror" # contains keen files, but we do not install them

RDEPEND="
	media-libs/libsdl2[opengl?,video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	virtual/minizip:=
	downloader? ( net-misc/curl )
	opengl? ( media-libs/libglvnd )
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-build.patch
	"${FILESDIR}"/${PN}-3.6.1-paths.patch
	"${FILESDIR}"/${P}-desktop-icon-ext.patch
)

src_prepare() {
	# Drop unneeded code to avoid CMake issues.
	rm -r tools || die

	cmake_src_prepare
}

src_configure() {
	filter-lto #858530

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DCCACHE_FOUND=no
		-DAPPDIR="${EPREFIX}"/usr/bin
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DGAMES_SHAREDIR="${EPREFIX}"/usr/share
		-DDOWNLOADER=$(usex downloader)
		-DUSE_OPENGL=$(usex opengl)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# default executable name is weird
	dosym CGeniusExe /usr/bin/${PN}

	# game data can be manually installed here
	keepdir /usr/share/${PN}/games
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Run ${PN} to start the game. It will search for game data"
	elog "in ~/.CommanderGenius/games and ${EPREFIX}${GAMESDIR}."
	elog "You can also specify paths in cgenius.cfg or pass paths as an"
	elog "argument."
	elog
	use downloader && elog "Data for some games can be downloaded from the menu."
	elog
	elog "Check your settings in ~/.CommanderGenius/cgenius.cfg after you have"
	elog "started the game for the first time."
	elog
	use opengl && elog "You may also want to set \"OpenGL = true\"."
}
