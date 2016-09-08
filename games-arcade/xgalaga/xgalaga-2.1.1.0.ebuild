# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A clone of the classic game Galaga for the X Window System"
HOMEPAGE="https://sourceforge.net/projects/xgalaga"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	sed -i \
		-e "/LEVELDIR\|SOUNDDIR/ s:prefix:datadir/${PN}:" \
		-e "/\/scores/ s:prefix:localstatedir/${PN}:" \
		configure \
		|| die "sed configure failed"
	sed -i \
		-e "/SOUNDDEFS/ s:(SOUNDSRVDIR):(SOUNDSRVDIR)/bin:" \
		-e 's:make ;:$(MAKE) ;:' \
		Makefile.in \
		|| die "sed Makefile.in failed"
}

src_install() {
	dogamesbin xgalaga xgal.sndsrv.oss xgalaga-hyperspace
	dodoc README README.SOUND CHANGES
	newman xgalaga.6x xgalaga.6

	insinto "${GAMES_DATADIR}/${PN}/sounds"
	doins sounds/*.raw

	insinto "${GAMES_DATADIR}/${PN}/levels"
	doins levels/*.xgl

	make_desktop_entry ${PN} XGalaga

	dodir "${GAMES_STATEDIR}/${PN}"
	touch "${D}${GAMES_STATEDIR}/${PN}/scores"
	fperms 660 "${GAMES_STATEDIR}/${PN}/scores"
	prepgamesdirs
}
