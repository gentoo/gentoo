# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Run games in a separate X session"
HOMEPAGE="http://xgame.tlhiv.com/"
SRC_URI="http://downloads.tlhiv.com/xgame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=
RDEPEND="dev-lang/perl"

src_install() {
	default
	dobin xgame
}
