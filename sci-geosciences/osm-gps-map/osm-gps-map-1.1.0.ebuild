# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2

DESCRIPTION="A GTK+ widget for displaying OpenStreetMap tiles"
HOMEPAGE="http://nzjrs.github.io/osm-gps-map/"
SRC_URI="https://github.com/nzjrs/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="
	>=dev-libs/glib-2.16.0:2
	>=net-libs/libsoup-2.4.0:2.4
	>=x11-libs/cairo-1.8.0
	>=x11-libs/gtk+-3.0:3[introspection]
	dev-libs/gobject-introspection"

DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	gnome-base/gnome-common:3
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-gtk-doc-module.patch"
	"${FILESDIR}/${P}-no-maintainer-mode.patch"
)

src_prepare() {
	gnome2_src_prepare
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable static-libs static)
}
