# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils

DESCRIPTION="Action/arcade recreation of SolarFox"
HOMEPAGE="http://www.pygame.org/shredwheat/solarwolf/"
SRC_URI="http://www.pygame.org/shredwheat/solarwolf/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pygame-1.5.6
	media-libs/sdl-mixer[mod,vorbis]
"
DEPEND=""

src_prepare() {
	default
	find . -name .xvpics -print0 | xargs -0 rm -fr
	gunzip dist/${PN}.6.gz || die #619948
}

src_install() {
	insinto /usr/share/${PN}
	doins -r code data *py
	make_wrapper ${PN} "python2 ./solarwolf.py" /usr/share/${PN}
	doicon dist/${PN}.png
	make_desktop_entry ${PN} SolarWolf
	einstalldocs
	doman dist/${PN}.6
}
