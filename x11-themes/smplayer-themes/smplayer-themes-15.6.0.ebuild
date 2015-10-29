# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="Icon themes for smplayer"
HOMEPAGE="http://smplayer.sourceforge.net/"
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-qt/qtcore:4"
RDEPEND="media-video/smplayer"

src_prepare() {
	# bug 544108
	sed -i -e "s|	rcc|	\"$(qt4_get_bindir)\"/rcc|" themes/Makefile || die

	# bug 544160
	sed -i -e 's/make/$(MAKE)/' Makefile || die
}

src_install() {
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
