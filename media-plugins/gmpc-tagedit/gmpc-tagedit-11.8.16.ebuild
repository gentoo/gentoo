# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="This plugin allows you to edit tags in your library"
HOMEPAGE="https://gmpc.fandom.com/wiki/GMPC_PLUGIN_TAGEDIT"
SRC_URI="https://download.sarine.nl/Programs/gmpc/11.8.16/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	>=media-sound/gmpc-${PV}
	media-libs/taglib:=
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gob
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

src_install() {
	default

	# plugins only
	find "${D}" -name '*.la' -delete || die
}
