# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/spout/spout-1.3.ebuild,v 1.8 2015/03/31 02:31:55 mr_bones_ Exp $

EAPI=5
inherit eutils games

MY_P="spout-unix-${PV}"
DESCRIPTION="Abstract Japanese caveflier / shooter"
HOMEPAGE="http://freshmeat.net/projects/spout/"
SRC_URI="http://rohanpm.net/files/old/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.6"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_install() {
	dogamesbin spout
	doicon spout.png
	make_desktop_entry spout "Spout"
	dodoc README
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "To play in fullscreen mode, do 'spout f'."
	elog "To play in a greater resolution, do 'spout x', where"
	elog "x is an integer; the larger x is, the higher the resolution."
	echo
	elog "To play:"
	elog "Accelerate - spacebar, enter, z, x"
	elog "Pause - escape"
	elog "Exit - shift+escape"
	elog "Rotate - left or right"
	echo
}
