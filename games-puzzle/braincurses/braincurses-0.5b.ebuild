# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="An ncurses-based mastermind clone"
HOMEPAGE="http://freshmeat.net/projects/braincurses/"
SRC_URI="mirror://sourceforge/braincurses/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=""
src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-as-needed.patch
	# fix buffer overflow (bug #301033)
	sed -i \
		-e 's/guessLabel\[2/guessLabel[3/' \
		curses/windows.cpp \
		|| die 'sed failed'
}

src_install() {
	dogamesbin braincurses
	dodoc README THANKS Changelog
	prepgamesdirs
}
