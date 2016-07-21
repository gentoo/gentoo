# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Abstract Shooting Game"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/noiz2sa_e.html http://sourceforge.net/projects/noiz2sa/"
SRC_URI="mirror://sourceforge/noiz2sa/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/sdl-mixer[vorbis]
	>=dev-libs/libbulletml-0.0.3
	virtual/opengl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}/src

src_prepare(){
	epatch "${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-underlink.patch
	sed -i \
		-e "s:/.noiz2sa.prf:/noiz2sa.prf:" \
		-e "s:getenv(\"HOME\"):\"${GAMES_STATEDIR}\":" \
		attractmanager.c || die

	cp makefile.lin Makefile || die
}

src_install(){
	local datadir="${GAMES_DATADIR}/${PN}"

	dogamesbin ${PN}
	dodir "${datadir}" "${GAMES_STATEDIR}"
	cp -r ../noiz2sa_share/* "${D}/${datadir}" || die
	dodoc ../readme*
	touch "${D}${GAMES_STATEDIR}/${PN}.prf"
	fperms 660 "${GAMES_STATEDIR}/${PN}.prf"
	prepgamesdirs
}
