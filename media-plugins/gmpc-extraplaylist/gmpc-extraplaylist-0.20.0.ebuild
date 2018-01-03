# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="This plugin adds a second pane showing the playlist"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_EXTRA_PLAYLIST"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-libs/libxml2:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
