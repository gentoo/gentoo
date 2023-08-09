# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Add SVG support to GTK without librsvg"
HOMEPAGE="http://michael.orlitzky.com/code/libsvgtiny-pixbuf.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libxml2:=
	media-libs/libsvgtiny:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	einfo "Updating pixbuf loader cache..."
	gdk-pixbuf-query-loaders --update-cache
}
