# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Super-Pang clone (destroy bouncing balloons with your grapnel)"
HOMEPAGE="http://www.loosersjuegos.com.ar/juegos/ceferino"
SRC_URI="mirror://debian/pool/main/c/ceferino/${PN}_${PV}+svn37.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND=">=media-libs/libsdl-1.2[video]
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${P}+svn37

src_prepare() {
	sed -i \
		-e '/^INCLUDES/s:\$(datadir)/locale:/usr/share/locale:' \
		src/Makefile.am || die
	eautoreconf
}

src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default
	newicon data/ima/icono.png ${PN}.png
	make_desktop_entry ceferino "Don Ceferino Hazaña"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! has_version "media-libs/sdl-mixer[mod]" ; then
		ewarn
		ewarn "To hear music, you will have to rebuild media-libs/sdl-mixer"
		ewarn "with the \"mod\" USE flag turned on."
		ewarn
	fi
}
