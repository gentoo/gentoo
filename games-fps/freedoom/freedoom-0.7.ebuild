# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/freedoom/freedoom-0.7.ebuild,v 1.8 2015/01/30 20:39:43 tupone Exp $
EAPI=5
inherit eutils games

DESCRIPTION="Freedoom - Open Source Doom resources"
HOMEPAGE="http://www.nongnu.org/freedoom/"
SRC_URI="mirror://nongnu/freedoom/freedoom-iwad/shareware/freedoom-demo-${PV}.zip
	mirror://nongnu/freedoom/freedoom-iwad/freedoom-iwad-${PV}.zip
	mirror://nongnu/freedoom/freedm/freedm-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/doom-data/${PN}
	doins */*.wad
	dodoc freedoom-iwad-${PV}/{CREDITS,ChangeLog,NEWS,README}
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
	ewarn "   for f in doom{1,2} freedm ; do"
	ewarn "       ln -sn freedoom/\${f}.wad"
	ewarn "   done"
}
