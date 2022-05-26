# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="a board game, up to 4 players, with AI and network"
HOMEPAGE="http://biloba.sourceforge.net/"
SRC_URI="mirror://sourceforge/biloba/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl:0[X,video,sound]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

PATCHES=(
	# X11 headers are checked but not used, everything is done through SDL
	"${FILESDIR}"/${P}-not-windows.patch
	"${FILESDIR}"/${P}-no-X11-dep.patch
	"${FILESDIR}/${P}-gcc-10.patch"
)

src_prepare() {
	default

	# "missing" file is old, and warns about --run not being supported
	rm missing || die
	eautoreconf
}

src_install() {
	default
	newicon -s 64 biloba_icon.png ${PN}.png
	make_desktop_entry biloba Biloba
}
