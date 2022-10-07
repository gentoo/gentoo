# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Plugin allows you to browse and preview music available on jamendo"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_JAMENDO"
SRC_URI="https://download.sarine.nl/Programs/gmpc/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-db/sqlite:3
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/gob
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
