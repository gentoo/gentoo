# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/0ad-data/0ad-data-0.0.17_alpha.ebuild,v 1.1 2014/10/12 22:38:15 hasufell Exp $

EAPI=5

inherit games

MY_P=0ad-${PV/_/-}
DESCRIPTION="Data files for 0ad"
HOMEPAGE="http://wildfiregames.com/0ad/"
SRC_URI="mirror://sourceforge/zero-ad/${MY_P}-unix-data.tar.xz"

LICENSE="GPL-2 CC-BY-SA-3.0 LPPL-1.3c BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm binaries/data/tools/fontbuilder/fonts/*.txt
}

src_install() {
	insinto "${GAMES_DATADIR}"/0ad
	doins -r binaries/data/*
	prepgamesdirs
}
