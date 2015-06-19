# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/tuxanci/tuxanci-99999999.ebuild,v 1.6 2015/01/05 20:12:38 tupone Exp $

EAPI=5

[[ ${PV} = 9999* ]] && GIT="git-2"
EGIT_REPO_URI="git://repo.or.cz/tuxanci.git"

inherit games cmake-utils ${GIT}

DESCRIPTION="Tuxanci is first tux shooter inspired by game Bulanci"
HOMEPAGE="http://www.tuxanci.org/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.${PN}.org/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi
LICENSE="GPL-2"

SLOT="0"
IUSE="debug dedicated +ipv6 nls opengl physfs +sound"

# >=x11-libs/cairo-1.8.8[X,svg]
RDEPEND="
	!dedicated? (
		>=media-libs/fontconfig-2.7.0
		media-libs/libsdl[X,opengl?]
		media-libs/sdl-ttf[X]
		>=media-libs/sdl-image-1.2.10[png]
		sound? (
			>=media-libs/sdl-mixer-1.2.11[vorbis]
		)
	)
	physfs? ( dev-games/physfs[zip] )
	!physfs? ( >=dev-libs/libzip-0.9 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local mycmakeargs+=(
		$(cmake-utils_use_with sound AUDIO)
		$(cmake-utils_use_build dedicated SERVER)
		$(cmake-utils_use_with nls)
		$(cmake-utils_use_with physfs)
		$(cmake-utils_use_with opengl)
		$(cmake-utils_use_enable ipv6)
		$(cmake-utils_use debug DEVELOPER)
	)

	mycmakeargs+=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DCMAKE_INSTALL_ICONDIR=${GAMES_DATADIR_BASE}/pixmaps/"
		"-DCMAKE_INSTALL_DESKTOPDIR=${GAMES_DATADIR_BASE}/applications/"
		"-DCMAKE_DATA_PATH=${GAMES_DATADIR}"
		"-DCMAKE_LOCALE_PATH=${GAMES_DATADIR_BASE}/locale/"
		"-DCMAKE_DOC_PATH=${GAMES_DATADIR_BASE}/doc/${PF}"
		"-DCMAKE_CONF_PATH=${GAMES_SYSCONFDIR}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	prepgamesdirs
}
