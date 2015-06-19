# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sdlroids/sdlroids-1.3.4-r3.ebuild,v 1.14 2015/03/31 16:11:28 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Asteroids Clone for X using SDL"
HOMEPAGE="http://david.hedbor.org/projects/sdlroids/"
SRC_URI="mirror://sourceforge/sdlroids/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's/$(SOUNDSDIR)/$(DESTDIR)$(SOUNDSDIR)/' \
		-e 's/$(GFXDIR)/$(DESTDIR)$(GFXDIR)/' Makefile.in \
		|| die "sed failed"
	epatch "${FILESDIR}"/${PV}-sound.patch
}

src_install() {
	default
	newicon icons/sdlroids-48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} SDLRoids ${PN}
	prepgamesdirs
}
