# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="http://alioth.debian.org/projects/tux4kids/"
SRC_URI="http://alioth.debian.org/frs/download.php/3270/tuxtype_w_fonts-${PV}.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="svg"

DEPEND="media-libs/libsdl:0[video]
	media-libs/sdl-pango
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-ttf
	svg? ( gnome-base/librsvg )"

S=${WORKDIR}/tuxtype_w_fonts-${PV}

src_prepare() {
	sed -i \
		-e 's:$(prefix)/share:'${GAMES_DATADIR}':g' \
		-e 's:$(prefix)/doc/$(PACKAGE):/usr/share/doc/'${PF}':g' \
		$(find -name Makefile.in) || die
}

src_configure() {
	egamesconf \
		--docdir=/usr/share/doc/${PF} \
		--localedir=/usr/share/locale \
		$(use_with svg rsvg)
}

src_install() {
	default
	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL,ABOUT-NLS}*
	doicon ${PN}.ico
	make_desktop_entry ${PN} TuxTyping /usr/share/pixmaps/${PN}.ico
	keepdir "${GAMES_SYSCONFDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/words"
	prepgamesdirs
}
