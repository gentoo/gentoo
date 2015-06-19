# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/rezerwar/rezerwar-0.4.2.ebuild,v 1.4 2015/02/24 22:26:02 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Puzzle game like the known tetromino and the average pipe games"
HOMEPAGE="http://tamentis.com/projects/rezerwar/"
SRC_URI="http://tamentis.com/projects/rezerwar/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/check_sdl$/d' \
		-e 's/-O2 //' \
		configure \
		|| die 'sed failed'
	sed -i \
		-e '/CC.*OBJECTS/s:$(CC):$(CC) $(LDFLAGS):' \
		mkfiles/Makefile.src \
		|| die "sed failed"
}

src_configure() {
	SDLCONFIG=sdl-config \
	TARGET_BIN="${GAMES_BINDIR}" \
	TARGET_DOC=/usr/share/doc/${PF} \
	TARGET_DATA="${GAMES_DATADIR}/${PN}" \
	./configure \
	|| die "configure failed"
	sed -i \
		-e '/TARGET_DOC/d' \
		Makefile \
		|| die "sed failed"
}

src_install() {
	dodir "${GAMES_BINDIR}"
	default
	dodoc doc/{CHANGES,README,TODO}
	make_desktop_entry rezerwar Rezerwar
	prepgamesdirs
}
