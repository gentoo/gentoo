# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/xgame/xgame-1.7.1.ebuild,v 1.9 2015/02/06 11:12:34 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="Run games in a separate X session"
HOMEPAGE="http://xgame.tlhiv.com/"
SRC_URI="http://downloads.tlhiv.com/xgame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=
RDEPEND="dev-lang/perl"

src_install() {
	dogamesbin xgame
	dodoc README
	prepgamesdirs
}
