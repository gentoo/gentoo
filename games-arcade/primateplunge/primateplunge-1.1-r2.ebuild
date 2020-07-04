# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="Help poor Monkey navigate his way down through treacherous areas"
HOMEPAGE="https://www.aelius.com/primateplunge/"
SRC_URI="https://www.aelius.com/${PN}/${P}.tar.gz"

LICENSE="Primate-Plunge"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist" #465850

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-AC_SUBST.patch
	eautoreconf
}

src_install() {
	default
	dodoc TIPS
	newicon graphics/idle.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Primate Plunge" /usr/share/pixmaps/${PN}.bmp
}
