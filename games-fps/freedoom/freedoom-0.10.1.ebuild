# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Freedoom - Open Source Doom resources"
HOMEPAGE="http://www.nongnu.org/freedoom/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/freedoom-${PV}.zip
	https://github.com/freedoom/freedoom/releases/download/v${PV}/freedm-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/doom-data/${PN}
	doins */*.wad
	dodoc ${P}/CREDITS
	dohtml ${P}/README.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "A Doom engine is required to play the wad"
	elog "but games-fps/doomsday doesn't count since it doesn't"
	elog "have the necessary features."
	echo
	ewarn "To play freedoom with Doom engines which do not support"
	ewarn "subdirectories, create symlinks by running the following:"
	ewarn "(Be careful of overwriting existing wads.)"
	ewarn
	ewarn "   cd ${GAMES_DATADIR}/doom-data"
	ewarn "   ln -sn freedoom/*.wad ."
	ewarn
}
