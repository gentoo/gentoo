# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="city simulation game"
HOMEPAGE="http://savannah.nongnu.org/projects/senken/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	>=media-libs/libsdl-1.2.4
	media-libs/sdl-image
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e "s:/usr/local/share:${GAMES_DATADIR}:" \
		lib/utils.h || die
	epatch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-warnings.patch
}
src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default

	dodir "${GAMES_DATADIR}"
	mv "${D}/${GAMES_PREFIX}/share/senken" "${D}/${GAMES_DATADIR}/" || die
	rm -rf "${D}/${GAMES_PREFIX}"/{include,lib,man,share} || die

	insinto "${GAMES_DATADIR}/senken/img"
	doins img/*.png

	find "${D}/${GAMES_DATADIR}/" -type f -exec chmod a-x \{\} +
	find "${D}/${GAMES_DATADIR}/" -name "Makefile.*" -exec rm -f \{\} +

	prepgamesdirs
}
