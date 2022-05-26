# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Image viewer and browser for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Gthumb"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cdr colord exif gnome-keyring gstreamer heif http jpegxl lcms raw slideshow svg tiff webp"

# libX11 dep is a workaround. See files/3.12.2-link-with-x11.patch
RDEPEND="
	x11-libs/libX11

	>=dev-libs/glib-2.54.0:2
	>=x11-libs/gtk+-3.16.0:3
	exif? ( >=media-gfx/exiv2-0.21:= )
	slideshow? (
		>=media-libs/clutter-1.12.0:1.0
		>=media-libs/clutter-gtk-1:1.0
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-gtk:1.0
	)
	raw? (
		>=media-libs/libraw-0.14:=
	)
	http? (
		>=net-libs/libsoup-2.42.0:2.4
		>=dev-libs/json-glib-0.15.0
		>=net-libs/webkit-gtk-1.10.0:4
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.11 )
	cdr? ( >=app-cdr/brasero-3.2.0 )
	svg? ( >=gnome-base/librsvg-2.34:2 )
	webp? ( >=media-libs/libwebp-0.2.0:= )
	jpegxl? ( >=media-libs/libjxl-0.3.0 )
	heif? ( >=media-libs/libheif-1.11:0= )
	lcms? ( >=media-libs/lcms-2.6:2 )
	colord? (
		>=x11-misc/colord-1.3
		>=media-libs/lcms-2.6:2
	)

	sys-libs/zlib
	media-libs/libjpeg-turbo:0=
	tiff? ( media-libs/tiff:= )
	media-libs/libpng:0=
	>=gnome-base/gsettings-desktop-schemas-0.1.4
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/appstream-0.14.6
	dev-util/glib-utils
	dev-util/itstool
	sys-devel/bison
	sys-devel/flex
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-link-with-x11.patch
)

src_configure() {
	local emesonargs=(
		-Drun-in-place=false
		$(meson_use exif exiv2)
		$(meson_use slideshow clutter)
		$(meson_use gstreamer)
		-Dlibchamplain=false # Upstream still doesn't seem to consider this ready
		$(meson_use colord)
		$(meson_use tiff libtiff)
		$(meson_use webp libwebp)
		$(meson_use jpegxl libjxl)
		$(meson_use heif libheif)
		$(meson_use raw libraw)
		$(meson_use svg librsvg)
		$(meson_use gnome-keyring libsecret)
		$(meson_use http webservices)
		$(meson_use cdr libbrasero)
	)

	# colord pulls in lcms2 anyway, so enable lcms with USE="colord -lcms"; some of upstream HAVE_COLORD code depends on HAVE_LCMS2
	if use lcms || use colord; then
		emesonargs+=( -Dlcms2=true )
	else
		emesonargs+=( -Dlcms2=false )
	fi
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
