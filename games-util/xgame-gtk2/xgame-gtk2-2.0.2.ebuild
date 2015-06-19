# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/xgame-gtk2/xgame-gtk2-2.0.2.ebuild,v 1.7 2015/03/12 04:03:25 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="Run games in a separate X session"
HOMEPAGE="http://xgame.tlhiv.com/"
SRC_URI="http://downloads.tlhiv.com/xgame/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/gtk2-perl-1.040"

src_install() {
	dogamesbin xgame-gtk2
	dodoc README
	prepgamesdirs
}
