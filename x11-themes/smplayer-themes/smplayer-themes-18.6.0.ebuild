# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Icon themes for smplayer"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 CC0-1.0 GPL-2 GPL-3+ LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:5"
RDEPEND="media-video/smplayer"

src_prepare() {
	default

	# bug 544108
	sed -i -e "s|	rcc|	\"$(qt5_get_bindir)\"/rcc|" themes/Makefile || die

	# bug 544160
	sed -i -e 's/make/$(MAKE)/' Makefile || die
}

src_install() {
	rm themes/Makefile || die
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
