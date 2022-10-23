# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="This plugin uses lyricwiki to fetch lyrics"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_LYRICWIKI"
SRC_URI="https://download.sarine.nl/Programs/gmpc/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-libs/libxml2:2"
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
