# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tuxanci is first tux shooter inspired by game Bulanci"
HOMEPAGE="https://repo.or.cz/w/tuxanci.git"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://repo.or.cz/tuxanci.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
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
	local mycmakeargs=(
		-DWITH_AUDIO=$(usex sound)
		-DBUILD_SERVER=$(usex dedicated)
		-DWITH_NLS=$(usex nls)
		-DWITH_PHYSFS=$(usex physfs)
		-DWITH_OPENGL=$(usex opengl)
		-DENABLE_IPV6=$(usex ipv6)
		-DDEVELOPER=$(usex debug)
		-DCMAKE_INSTALL_ICONDIR="${EPREFIX}"/usr/pixmaps/
		-DCMAKE_INSTALL_DESKTOPDIR="${EPREFIX}"/usr/applications/
		-DCMAKE_DATA_PATH="${EPREFIX}"/usr/share/
		-DCMAKE_LOCALE_PATH="${EPREFIX}"/usr/share/locale/
		-DCMAKE_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		-DCMAKE_CONF_PATH="${EPREFIX}"/etc
	)
	cmake-utils_src_configure
}
