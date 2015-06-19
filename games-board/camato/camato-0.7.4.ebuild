# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/camato/camato-0.7.4.ebuild,v 1.6 2014/10/30 16:50:32 mr_bones_ Exp $

EAPI=5
inherit versionator games

MY_PV=$(replace_all_version_separators _)
DESCRIPTION="A map editor for the game gnocatan"
HOMEPAGE="http://yusei.ragondux.com/loisirs_jdp_catane_camato-en.html"
SRC_URI="http://yusei.ragondux.com/files/gnocatan/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-ruby/ruby-gtk2"
RDEPEND=${DEPEND}

src_prepare() {
	rm -f Makefile
	sed -i -e "s:/usr/share:${GAMES_DATADIR}:" ${PN} || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *.rb img
	dodoc ChangeLog README
	prepgamesdirs
}
