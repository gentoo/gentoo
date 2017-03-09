# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/EyeOfGnome"

LICENSE="GPL-2+"
SLOT="1"

IUSE="debug +exif +introspection +jpeg lcms +svg tiff xmp"
REQUIRED_USE="exif? ( jpeg )"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.42.0:2[dbus]
	>=dev-libs/libpeas-0.7.4:=[gtk]
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=x11-libs/gtk+-3.19.11:3[introspection,X]
	>=x11-misc/shared-mime-info-0.20

	>=x11-libs/gdk-pixbuf-2.30.0:2[jpeg?,tiff?]
	x11-libs/libX11

	exif? ( >=media-libs/libexif-0.6.14 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	svg? ( >=gnome-base/librsvg-2.36.2:2 )
	xmp? ( media-libs/exempi:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.16
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable introspection) \
		$(use_with jpeg libjpeg) \
		$(use_with exif libexif) \
		$(use_with lcms cms) \
		$(use_with xmp) \
		$(use_with svg librsvg)
}
