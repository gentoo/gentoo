# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="Guide the blob along the conveyer belt collecting the red blobs"
HOMEPAGE="http://www.cloudsprinter.com/software/conveysdl/"
SRC_URI="http://www.cloudsprinter.com/software/conveysdl/${P/-/.}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_prepare() {
	# Incomplete readme
	sed -i \
		-e 's:I k:use -nosound to disable sound\n\nI k:' \
		readme || die

	sed -i \
		-e 's:SDL_Mi:SDL_mi:' \
		main.c || die

	epatch \
		"${FILESDIR}"/${P}-arrays.patch \
		"${FILESDIR}"/${P}-speed.patch
}

src_compile() {
	emake main \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} $(sdl-config --cflags) \
			-DDATA_PREFIX=\\\"${GAMES_DATADIR}/${PN}/\\\" \
			-DENABLE_SOUND" \
		LDLIBS="-lSDL_mixer $(sdl-config --libs)"
}

src_install() {
	newgamesbin main ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r gfx sounds levels
	newicon gfx/jblob.bmp ${PN}.bmp
	make_desktop_entry ${PN} Convey /usr/share/pixmaps/${PN}.bmp
	dodoc readme
	prepgamesdirs
}
