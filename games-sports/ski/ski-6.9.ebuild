# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/ski/ski-6.9.ebuild,v 1.3 2015/05/13 09:27:53 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 games

DESCRIPTION="A simple text-mode skiing game"
HOMEPAGE="http://www.catb.org/~esr/ski/"
SRC_URI="http://www.catb.org/~esr/ski/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	dogamesbin ski
	dodoc NEWS README
	doman ski.6
	domenu ski.desktop
	doicon ski.png
	prepgamesdirs
	python_fix_shebang "${ED}${GAMES_BINDIR}"
}
