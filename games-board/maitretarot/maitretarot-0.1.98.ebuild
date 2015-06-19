# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/maitretarot/maitretarot-0.1.98.ebuild,v 1.10 2015/03/12 10:06:14 ago Exp $

EAPI=5
inherit games

DESCRIPTION="server for the french tarot game maitretarot"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="http://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot"
RDEPEND=${DEPEND}

src_configure() {
	egamesconf \
		--with-default-config-file="${GAMES_SYSCONFDIR}/maitretarotrc.xml"
}

src_install() {
	default
	prepgamesdirs
}
