# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="http://lgames.sourceforge.net/LBreakout/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.5"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/^sdir=/s:$datadir/games:$datadir:' \
		-e '/^hdir=/s:/var/lib/games:$localstatedir:' \
		configure \
		|| die "sed failed"
}

src_install() {
	HTML_DOCS="lbreakout/manual/*"
	default
}
