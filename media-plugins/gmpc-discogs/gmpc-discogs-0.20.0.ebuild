# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="This plugin fetches artist and album images from discogs"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_DISCOGS"
SRC_URI="https://download.sarine.nl/Programs/gmpc/0.20.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-libs/libxml2:=
	|| (
		x11-libs/gdk-pixbuf:2[jpeg]
		x11-libs/gtk+:2[jpeg]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
