# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/atakks/atakks-1.0.ebuild,v 1.12 2014/10/10 15:22:00 ago Exp $

EAPI=5
inherit eutils games

MY_P=${P/-/_}
DESCRIPTION="A clone of Ataxx"
HOMEPAGE="http://team.gcu-squad.org/~fab"
# no version upstream
#SRC_URI="http://team.gcu-squad.org/~fab/down/${PN}.tgz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Modify game data paths
	sed -i \
		-e "s:SDL_LoadBMP(\":SDL_LoadBMP(\"${GAMES_DATADIR}/${PN}/:" \
		main.c || die

	epatch "${FILESDIR}"/${PV}-warnings.patch \
		"${FILESDIR}"/${P}-as-needed.patch
}

src_compile() {
	emake E_CFLAGS="${CFLAGS}"
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins *bmp
	newicon icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Atakks /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
