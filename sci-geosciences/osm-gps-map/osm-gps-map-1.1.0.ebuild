# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A GTK+ viewer for OpenStreetMap files"
HOMEPAGE="http://nzjrs.github.com/osm-gps-map/"
SRC_URI="https://github.com/nzjrs/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND="
	>=dev-libs/glib-2.16.0:2
	>=net-libs/libsoup-2.4.0:2.4
	>=x11-libs/cairo-1.8.0
	>=x11-libs/gtk+-3.0:3[introspection]
	dev-libs/gobject-introspection"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-no-maintainer-mode.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}
