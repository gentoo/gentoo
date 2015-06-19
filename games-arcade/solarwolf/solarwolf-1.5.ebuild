# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/solarwolf/solarwolf-1.5.ebuild,v 1.21 2015/03/31 16:21:19 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="action/arcade recreation of SolarFox"
HOMEPAGE="http://www.pygame.org/shredwheat/solarwolf/"
SRC_URI="http://www.pygame.org/shredwheat/solarwolf/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-python/pygame-1.5.6
	media-libs/sdl-mixer[mod,vorbis]"

src_prepare() {
	find . -name .xvpics -print0 | xargs -0 rm -fr
}

src_install() {
	insinto "$(games_get_libdir)"/${PN}
	doins -r code data *py
	games_make_wrapper ${PN} "python2 ./solarwolf.py" "$(games_get_libdir)"/${PN}
	doicon dist/${PN}.png
	make_desktop_entry ${PN} SolarWolf
	dodoc readme.txt
	doman dist/${PN}.6.gz
	prepgamesdirs
}
