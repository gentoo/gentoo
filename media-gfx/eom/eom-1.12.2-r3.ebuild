# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit mate python-single-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="The MATE image viewer"
LICENSE="GPL-2"
SLOT="0"

IUSE="X debug dbus exif gtk3 +introspection jpeg lcms python svg tiff xmp"

REQUIRED_USE="
	gtk3? ( !python )
	python? ( ${PYTHON_REQUIRED_USE} )
	"

RDEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2:2
	gnome-base/dconf:0
	>=mate-base/mate-desktop-1.9.1[gtk3(-)=]
	sys-libs/zlib:0
	x11-libs/cairo:0
	>=x11-libs/gdk-pixbuf-2.4:2[introspection?,jpeg?,tiff?]
	x11-libs/libX11:0
	>=x11-misc/shared-mime-info-0.20:0
	virtual/libintl:0
	dbus? ( >=dev-libs/dbus-glib-0.71:0 )
	exif? (
		>=media-libs/libexif-0.6.14:0
		virtual/jpeg:0
	)
	!gtk3? ( >=x11-libs/gtk+-2.18:2[introspection?] )
	gtk3? ( >=x11-libs/gtk+-3.0:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2.15.1:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.13:2[${PYTHON_USEDEP}]
	)
	svg? ( >=gnome-base/librsvg-2.36.2:2 )
	xmp? ( >=media-libs/exempi-1.99.5:2 )
	!!media-gfx/mate-image-viewer"

DEPEND="${RDEPEND}
	app-text/yelp-tools:0
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

PATCHES=( "${FILESDIR}/${P}-gtk3-svg.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_enable python) \
		$(use_with X x) \
		$(use_with dbus) \
		$(use_with exif libexif) \
		$(use_with jpeg libjpeg) \
		$(use_with lcms cms) \
		$(use_with svg librsvg) \
		$(use_with xmp)
}
