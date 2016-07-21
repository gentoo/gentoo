# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Help robot find kitten"
HOMEPAGE="http://robotfindskitten.org/"
SRC_URI="mirror://sourceforge/rfk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS" \
		default
	insinto "${GAMES_DATADIR}"/${PN}
	doins nki/vanilla.nki
	prepgamesdirs
}
