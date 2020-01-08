# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5"
RDEPEND="media-video/smplayer"

src_prepare() {
	default

	sed -i -e 's/make/$(MAKE)/' Makefile || die
	sed -i -e "s|rcc -binary|$(qt5_get_bindir)/&|" themes/Makefile || die
}

src_install() {
	rm themes/Makefile
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
