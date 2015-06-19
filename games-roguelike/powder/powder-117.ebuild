# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/powder/powder-117.ebuild,v 1.6 2014/08/28 07:10:23 mr_bones_ Exp $

EAPI=5
inherit flag-o-matic games

MY_P=${P/-/}_src

DESCRIPTION="A game in the genre of Rogue, Nethack, and Diablo. Emphasis is on tactical play"
HOMEPAGE="http://www.zincland.com/powder/"
SRC_URI="http://www.zincland.com/powder/release/${MY_P}.tar.gz"

LICENSE="CC-Sampling-Plus-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_compile() {
	append-cxxflags -DCHANGE_WORK_DIRECTORY
	emake -C port/linux premake
	emake -C port/linux powder
}

src_install() {
	dogamesbin port/linux/${PN}
	dodoc README.TXT CREDITS.TXT
	prepgamesdirs
}

pkg_postinst() {
	elog "While the highscore is kept, save games are never preserved between"
	elog "versions. Please wait until your current character dies before upgrading."
	games_pkg_postinst
}
