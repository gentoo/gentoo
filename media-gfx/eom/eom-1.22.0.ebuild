# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="The MATE image viewer"
LICENSE="GPL-2"
SLOT="0"

IUSE="X debug exif +introspection jpeg lcms svg tiff xmp"

RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libpeas-1.8.0[gtk]
	>=dev-libs/libxml2-2:2
	gnome-base/dconf
	>=mate-base/mate-desktop-1.17.0
	sys-libs/zlib
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,jpeg?,tiff?]
	>=x11-libs/gtk+-3.22:3[introspection?]
	x11-libs/libX11
	>=x11-misc/shared-mime-info-0.20
	virtual/libintl
	exif? (
		>=media-libs/libexif-0.6.14
		virtual/jpeg:0
	)
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	svg? ( >=gnome-base/librsvg-2.36.2:2 )
	xmp? ( >=media-libs/exempi-1.99.5:2 )
	!!media-gfx/mate-image-viewer"

DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	mate_src_configure \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_with X x) \
		$(use_with exif libexif) \
		$(use_with jpeg libjpeg) \
		$(use_with lcms cms) \
		$(use_with svg librsvg) \
		$(use_with xmp)
}
