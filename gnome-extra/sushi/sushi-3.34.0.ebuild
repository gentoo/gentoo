# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson xdg

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~sparc x86"
IUSE="office wayland +X"
REQUIRED_USE="|| ( wayland X )"

# Optional app-office/libreoffice support (OOo to pdf and then preview)
COMMON_DEPEND="
	media-libs/libepoxy
	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	>=x11-libs/gdk-pixbuf-2.23.0[introspection]
	>=dev-libs/glib-2.29.14:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[introspection,wayland?,X?]
	>=x11-libs/gtksourceview-4.0.3:4[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	>=dev-libs/gobject-introspection-1.54:=
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]
	>=dev-libs/gjs-1.40
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
	office? ( app-office/libreoffice )
"

PATCHES=(
	# origin/master updates up to 2020-03-10, primarily for gtk[-wayland] fixes
	"${WORKDIR}"/patches
)

src_configure() {
	meson_src_configure \
		$(meson_feature wayland) \
		$(meson_feature X X11)
}

src_compile() {
	local -x GST_PLUGIN_SYSTEM_PATH_1_0=
	meson_src_compile
}
