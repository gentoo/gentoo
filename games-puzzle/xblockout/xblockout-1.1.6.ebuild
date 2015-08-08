# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools flag-o-matic eutils games

DESCRIPTION="X Window block dropping game in 3 Dimension"
HOMEPAGE="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/"
SRC_URI="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/xbl-${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"

S=${WORKDIR}/xbl-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-font.patch
	sed -i \
		-e '/^CC/d' \
		-e 's:-lm:-lm -lX11:' \
		-e '/DGROUP_GID/d' \
		-e "s:-g$:${CFLAGS}:" \
		Makefile.in || die
	# Don't know about other archs. --slarti
	use amd64 && filter-flags "-fweb"
	eautoreconf
}

src_compile() {
	emake \
		USE_SETGID= \
		SCOREDIR="${GAMES_DATADIR}/${PN}" \
		RESOURCEDIR="${GAMES_DATADIR}/${PN}" \
		LDOPTIONS="${LDFLAGS}"
}

src_install() {
	newgamesbin bl xbl

	insinto "${GAMES_DATADIR}"/${PN}
	newins Xbl.ad Xbl

	newman xbl.man xbl.6
	dodoc README xbl-README
	dohtml *.html *.gif
	make_desktop_entry xbl XBlockOut
	prepgamesdirs
}
