# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="This plugin allows you to browse and preview available albums on magnatune.com"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_MAGNATUNE"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	dev-libs/libxml2:2
	dev-db/sqlite:3
	>=gnome-base/libglade-2
	x11-libs/gdk-pixbuf:2[jpeg]
	x11-libs/gtk+:2"
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
