# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/OilWar/OilWar-1.2.1-r1.ebuild,v 1.5 2013/11/12 05:18:50 patrick Exp $

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="Evil army is attacking your country and tries to steal your oil"
HOMEPAGE="http://linux.softpedia.com/get/GAMES-ENTERTAINMENT/RTS/OilWar-15354.shtml"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^CXXCOMPILE/s:$(CPPFLAGS):$(SDL_CFLAGS):' \
		-e '/^datafiledir/s:/games/:/:' \
		-e '/install-data-am:/s:\\::' \
		-e '/install-data-local$/d' \
		Makefile.in || die
}

src_configure() {
	egamesconf --enable-sound
}

src_install() {
	default
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry oilwar ${PN}
	fperms 664 "${GAMES_STATEDIR}/oilwar.scores"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
