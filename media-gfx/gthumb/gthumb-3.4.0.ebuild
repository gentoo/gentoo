# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Image viewer and browser for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/gthumb"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cdr exif gnome-keyring gstreamer http jpeg json lcms raw slideshow svg tiff test webkit webp"

COMMON_DEPEND="
	>=dev-libs/glib-2.36.0:2[dbus]
	>=x11-libs/gtk+-3.10.0:3

	media-libs/libpng:0=
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM

	cdr? ( >=app-cdr/brasero-3.2 )
	exif? ( >=media-gfx/exiv2-0.21:= )
	gnome-keyring? ( >=app-crypt/libsecret-0.11 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	http? ( >=net-libs/libsoup-2.42.0:2.4 )
	jpeg? ( virtual/jpeg:0= )
	json? ( >=dev-libs/json-glib-0.15.0 )
	lcms? ( >=media-libs/lcms-2.6:2 )
	slideshow? (
		>=media-libs/clutter-1.12.0:1.0
		>=media-libs/clutter-gtk-1:1.0 )
	svg? ( >=gnome-base/librsvg-2.34 )
	tiff? ( media-libs/tiff:= )
	raw? ( >=media-libs/libraw-0.14:= )
	!raw? ( media-gfx/dcraw )
	webkit? ( net-libs/webkit-gtk:4 )
	webp? ( >=media-libs/libwebp-0.2.0 )
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gsettings-desktop-schemas-0.1.4
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.35
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )
"
# eautoreconf needs:
#	gnome-base/gnome-common

src_prepare() {
	# Remove unwanted CFLAGS added with USE=debug
	sed -e 's/CFLAGS="$CFLAGS -g -O0 -DDEBUG"//' \
		-i configure.ac -i configure || die

	gnome2_src_prepare
}

src_configure() {
	# Upstream says in configure help that libchamplain support
	# crashes frequently
	gnome2_src_configure \
		--disable-static \
		--disable-libchamplain \
		$(use_enable cdr libbrasero) \
		$(use_enable exif exiv2) \
		$(use_enable gnome-keyring libsecret) \
		$(use_enable gstreamer) \
		$(use_enable http libsoup) \
		$(use_enable jpeg) \
		$(use_enable json libjson-glib) \
		$(use_enable lcms lcms2) \
		$(use_enable raw libraw) \
		$(use_enable slideshow clutter) \
		$(use_enable svg librsvg) \
		$(use_enable test test-suite) \
		$(use_enable tiff) \
		$(use_enable webkit webkit2) \
		$(use_enable webp libwebp)
}
