# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="https://www.smplayer.info"
SRC_URI="https://downloads.sourceforge.net/project/smplayer/SMPlayer-skins/${PV}/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DEPEND="dev-qt/qtbase:6"
RDEPEND="media-video/smplayer"

src_prepare() {
	default

	sed -i "s|rcc -binary|$(qt6_get_bindir)/&|" themes/Makefile || die
	sed -i 's/make/$(MAKE)/' Makefile || die
}

src_install() {
	rm themes/Makefile || die
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
