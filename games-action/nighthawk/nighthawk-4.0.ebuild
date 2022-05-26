# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Tribute to Paradroid by Andrew Braybrook"
HOMEPAGE="https://night-hawk.sourceforge.io/"
SRC_URI="mirror://sourceforge/night-hawk/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/freeglut
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libvorbis
	media-libs/openal
	virtual/glu"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i '/SCORES_PATH/s|/var/tmp|${EPREFIX}/var/games|' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DBUILD_NED=yes )

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc WHATS_NEW

	dodir /var/games
	> "${ED}"/var/games/${PN}.scores || die

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.scores
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.scores

	newicon data/xpm/v4/nighthawk_desktop_icon.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
