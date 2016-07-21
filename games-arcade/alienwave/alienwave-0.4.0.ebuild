# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="An ncurses-based Xenon clone"
HOMEPAGE="http://www.alessandropira.org/alienwave/aw.html"
SRC_URI="http://www.alessandropira.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dogamesbin alienwave
	dodoc TO_DO README STORY
	prepgamesdirs
}
