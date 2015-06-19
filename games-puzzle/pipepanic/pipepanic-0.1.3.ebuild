# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/pipepanic/pipepanic-0.1.3.ebuild,v 1.6 2015/02/24 22:05:08 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A simple pipe connecting game"
HOMEPAGE="http://www.users.waitrose.com/~thunor/pipepanic/"
SRC_URI="http://www.users.waitrose.com/~thunor/pipepanic/dload/${P}-source.tar.gz"

LICENSE="GPL-2 FreeArt"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	# change harcoded data paths to match the install directory
	sed -i \
		-e "s:/opt/QtPalmtop/share/pipepanic/:${GAMES_DATADIR}/${PN}/:" \
		main.h \
		|| die "sed failed"
}

src_install() {
	dogamesbin "${PN}"

	insinto "${GAMES_DATADIR}/${PN}"
	doins *.bmp
	newicon PipepanicIcon64.png ${PN}.png
	make_desktop_entry ${PN} "Pipepanic"

	dodoc AUTHORS ChangeLog README

	prepgamesdirs
}
