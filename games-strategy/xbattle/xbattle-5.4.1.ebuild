# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/xbattle/xbattle-5.4.1.ebuild,v 1.14 2015/03/30 18:42:25 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="A multi-player game of strategy and coordination"
HOMEPAGE="http://www.cgl.uwaterloo.ca/~jdsteele/xbattle.html"
SRC_URI="ftp://cns-ftp.bu.edu/pub/xbattle/${P}.tar.gz"

LICENSE="xbattle"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libX11
	!games-strategy/xbattleai"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-text/rman
	x11-misc/imake"

src_prepare() {
	sed -i \
		-e "s:/export/home/lesher/:${GAMES_DATADIR}/${PN}/:" Imakefile || die
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dogamesbin xbattle
	newgamesbin tutorial1 xbattle-tutorial1
	newgamesbin tutorial2 xbattle-tutorial2
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r xbas/ xbos/ xbts/ "${D}${GAMES_DATADIR}/${PN}/" || die
	newman xbattle.man xbattle.6
	dodoc README xbattle.dot
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog 'You may be interested by these tutorials:'
	elog '    xbattle-tutorial1'
	elog '    xbattle-tutorial2'
}
