# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="This plugin calls ogg123 and points it at mpd's shoutstream"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_SHOUT"
SRC_URI="https://download.sarine.nl/Programs/gmpc/0.20.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	media-sound/vorbis-tools[ogg123]
	dev-libs/libxml2:=
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
