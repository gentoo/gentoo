# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="https://downloads.sourceforge.net/smplayer/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DEPEND="dev-qt/qtbase:6"
RDEPEND="media-video/smplayer"

src_prepare() {
	default

	sed -i -e 's/make/$(MAKE)/' Makefile || die
	sed -i -e "s|rcc -binary|$(qt6_get_libexecdir)/&|" themes/Makefile || die
}

src_install() {
	rm themes/Makefile || die
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
