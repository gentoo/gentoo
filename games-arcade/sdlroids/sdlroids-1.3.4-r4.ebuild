# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Asteroids Clone for X using SDL"
HOMEPAGE="http://david.hedbor.org/projects/sdlroids/"
SRC_URI="mirror://sourceforge/sdlroids/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e 's/$(SOUNDSDIR)/$(DESTDIR)$(SOUNDSDIR)/' \
		-e 's/$(GFXDIR)/$(DESTDIR)$(GFXDIR)/' Makefile.in \
		|| die "sed failed"
	eapply "${FILESDIR}"/${PV}-sound.patch
}

src_install() {
	default
	newicon icons/sdlroids-48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} SDLRoids ${PN}
}
