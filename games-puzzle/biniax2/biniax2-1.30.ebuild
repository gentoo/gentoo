# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/biniax2/biniax2-1.30.ebuild,v 1.5 2015/02/13 20:07:50 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Logic game with arcade and tactics modes"
HOMEPAGE="http://biniax.com/"
SRC_URI="http://mordred.dir.bg/biniax/${P}-fullsrc.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"
S=${WORKDIR}

src_prepare() {
	rm -f data/Thumbs.db
	sed -i \
		-e "s:data/:${GAMES_DATADIR}/${PN}/:" \
		desktop/{gfx,snd}.c \
		|| die
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-dotfiles.patch
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} Biniax-2
	prepgamesdirs
}
