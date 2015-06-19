# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake1-teamfortress/quake1-teamfortress-2.9.ebuild,v 1.5 2015/01/31 06:57:36 tupone Exp $
EAPI=5
inherit eutils games

DESCRIPTION="The classic Team Fortress Quake World mod"
HOMEPAGE="http://www.planetfortress.com/teamfortress/"
SRC_URI="mirror://gentoo/tf28.zip
	mirror://gentoo/tf29qw.zip"

LICENSE="quake1-teamfortress"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	echo ">>> Unpacking tf28.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/tf28.zip || die "unpacking tf28.zip failed"
	cd fortress
	echo ">>> Unpacking tf29qw.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/tf29qw.zip || die "unpacking tf29qw.zip failed"

	edos2unix $(find . -name '*.txt' -o -name '*.cfg')
	mv server.cfg server.example.cfg
}

src_install() {
	insinto "${GAMES_DATADIR}/quake1"
	doins -r *
	prepgamesdirs
}
