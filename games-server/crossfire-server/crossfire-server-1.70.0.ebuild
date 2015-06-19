# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/crossfire-server/crossfire-server-1.70.0.ebuild,v 1.4 2013/02/14 22:05:28 ago Exp $

EAPI=5
inherit eutils games

MY_P="${P/-server/}"
DESCRIPTION="server for the crossfire clients"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${MY_P}.tar.gz
	mirror://sourceforge/crossfire/crossfire-${PV}.maps.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"
RESTRICT="test"

DEPEND="net-misc/curl
	X? (
		x11-libs/libXaw
		media-libs/libpng:0
	)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -f "${WORKDIR}"/maps/Info/combine.pl # bug #236205
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir "${GAMES_STATEDIR}"/crossfire/{datafiles,maps,players,template-maps,unique-items}
	dodoc AUTHORS ChangeLog DEVELOPERS NEWS README TODO
	insinto "${GAMES_DATADIR}/crossfire"
	doins -r "${WORKDIR}/maps"
	prepgamesdirs
}
