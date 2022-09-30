# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="This plugin shows your music collection in albums"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_ALBUMVIEW"
SRC_URI="https://download.sarine.nl/Programs/gmpc/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
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

	# plugins only
	find "${D}" -name '*.la' -delete || die
}
