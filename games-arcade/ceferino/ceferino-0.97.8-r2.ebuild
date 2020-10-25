# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="Super-Pang clone (destroy bouncing balloons with your grapnel)"
HOMEPAGE="http://www.losersjuegos.com.ar/juegos/ceferino"
SRC_URI="mirror://debian/pool/main/c/ceferino/${PN}_${PV}+svn37.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	>=media-libs/libsdl-1.2[video]
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${P}+svn37"

src_prepare() {
	default
	sed -i \
		-e '/^INCLUDES/s:\$(datadir)/locale:/usr/share/locale:' \
		src/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	newicon data/ima/icono.png ${PN}.png
	make_desktop_entry ceferino "Don Ceferino Hazaña"
}

pkg_postinst() {
	if ! has_version "media-libs/sdl-mixer[mod]" ; then
		ewarn
		ewarn "To hear music, you will have to rebuild media-libs/sdl-mixer"
		ewarn "with the \"mod\" USE flag turned on."
		ewarn
	fi
}
