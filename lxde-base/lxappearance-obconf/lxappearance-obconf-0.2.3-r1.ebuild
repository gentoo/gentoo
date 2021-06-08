# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LXAppearance plugin for configuring OpenBox"
HOMEPAGE="https://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	>=lxde-base/lxappearance-0.6.3-r2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/pango
	x11-wm/openbox
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-static \
		--enable-gtk3
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
