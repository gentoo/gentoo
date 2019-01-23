# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/EyeOfGnome"

LICENSE="GPL-2+"
SLOT="1"

IUSE="+exif gtk-doc +introspection +jpeg lcms +svg xmp tiff"
REQUIRED_USE="exif? ( jpeg )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.53.4:2
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=dev-libs/libpeas-0.7.4:=[gtk]
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=x11-misc/shared-mime-info-0.20
	>=x11-libs/gdk-pixbuf-2.36.5:2[jpeg?,tiff?]
	>=x11-libs/gtk+-3.22.0:3[introspection,X]

	exif? ( >=media-libs/libexif-0.6.14 )
	lcms? ( media-libs/lcms:2 )
	xmp? ( media-libs/exempi:2 )
	jpeg? ( virtual/jpeg:0 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	svg? ( >=gnome-base/librsvg-2.36.2:2 )

	x11-libs/libX11
"
DEPEND="${RDEPEND}
	gtk-doc? ( >=dev-util/gtk-doc-1.16 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use exif libexif)
		$(meson_use lcms cms)
		$(meson_use xmp)
		$(meson_use jpeg libjpeg)
		$(meson_use svg librsvg)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_icon_cache_update
}
