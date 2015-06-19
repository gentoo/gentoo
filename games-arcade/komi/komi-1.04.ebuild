# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/komi/komi-1.04.ebuild,v 1.7 2015/01/05 10:48:35 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Komi the Space Frog - simple SDL game of collection"
HOMEPAGE="http://komi.sourceforge.net"
SRC_URI="mirror://sourceforge/komi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"
DOCS=( CHANGELOG.txt README.txt TROUBLESHOOTING.txt )

src_prepare() {
	epatch "${FILESDIR}"/${PV}-DESTDIR.patch \
		"${FILESDIR}"/${P}-install.patch
	sed -i \
		-e "/^BINPATH/s:=.*:=${GAMES_BINDIR}/:" \
		-e "/^DATAPATH/s:=.*:=${GAMES_DATADIR}/${PN}/:" \
		-e '/^SDL_LIB/s:$: $(LDFLAGS):' \
		-e '/^SDL_LIB/s:--static-:--:' \
		Makefile \
		|| die "sed failed"
}

src_compile() {
	emake ECFLAGS="${CFLAGS}"
}

src_install() {
	default
	newicon komidata/sprites_komi.bmp ${PN}.bmp
	make_desktop_entry komi Komi /usr/share/pixmaps/${PN}.bmp
	doman komi.6
	prepgamesdirs
}
