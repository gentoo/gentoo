# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Super-Pang clone (destroy bouncing balloons with your grapnel)"
HOMEPAGE="http://www.losersjuegos.com.ar/juegos/ceferino"
SRC_URI="mirror://debian/pool/main/c/ceferino/${PN}_${PV}+svn37.orig.tar.gz"
S+="+svn37"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-audio.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	newicon data/ima/icono.png ${PN}.png
	make_desktop_entry ${PN} "Don Ceferino Hazaña"
}
