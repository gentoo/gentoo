# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Help poor Monkey navigate his way down through treacherous areas"
HOMEPAGE="https://www.aelius.com/primateplunge/"
SRC_URI="https://www.aelius.com/${PN}/${P}.tar.gz"

LICENSE="Primate-Plunge"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist" #465850

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-AC_SUBST.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc TIPS

	newicon graphics/idle.bmp primateplunge.bmp
	make_desktop_entry primateplunge "Primate Plunge" /usr/share/pixmaps/primateplunge.bmp
}
