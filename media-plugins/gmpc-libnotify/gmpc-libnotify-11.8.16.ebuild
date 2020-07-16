# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="This plugin sends an announcement to the notification daemon on song change"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_LIBNOTIFY"
SRC_URI="https://download.sarine.nl/Programs/gmpc/11.8.16/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-libs/libxml2:2
	x11-libs/libnotify"
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
