# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Program for creating labels and business cards"
HOMEPAGE="https://github.com/jimevins/glabels-qt"

LICENSE="GPL-3+ LGPL-3+ CC-BY-SA-3.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="barcode eds"

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=x11-libs/gtk+-3.14.0:3
	>=dev-libs/libxml2-2.9.0:2
	>=gnome-base/librsvg-2.39.0:2
	>=x11-libs/cairo-1.14.0
	>=x11-libs/pango-1.36.1
	barcode? (
		>=app-text/barcode-0.98
		>=media-gfx/qrencode-3.1
	)
	eds? ( >=gnome-extra/evolution-data-server-3.12.0:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/itstool
	dev-build/gtk-doc-am
	>=dev-util/intltool-0.28
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/glabels-externs.patch # Fix compilation with -fno-common/gcc10; patch from Fedora
	"${FILESDIR}"/glabels-gcc14.patch
)

src_configure() {
	gnome2_src_configure \
		$(use_with eds libebook)
}
