# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils games

DESCRIPTION="Port of ID's doom to SDL"
HOMEPAGE="http://firehead.org/~jessh/lsdldoom/"
SRC_URI="http://www.lbjhs.net/~jessh/lsdldoom/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="sparc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-net
	!games-fps/prboom
	games-fps/doom-data"

src_unpack() {
	unpack ${A}
	cp -r "${S}"{,.orig}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${PV}-gentoo-paths.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-keys.patch \
		"${FILESDIR}"/${PV}-gcc34.patch #77846
}

src_compile() {
	# The SDL_mixer implementation is VERY broken ...
	# it relies on internal function calls rather than
	# the exported API ... bad programmer !
	# i386-asm -> build failure
	# cpu-opt -> just adds -mcpu crap to CFLAGS
	ac_cv_lib_SDL_mixer_Mix_LoadMUS=no \
	egamesconf \
		--disable-i386-asm \
		--disable-cpu-opt \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	prepalldocs
	dodoc ChangeLog
	prepgamesdirs
}
