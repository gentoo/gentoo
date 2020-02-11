# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson vala virtualx xdg-utils

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="https://wiki.gnome.org/Apps/Cheese"

LICENSE="GPL-2+"
SLOT="0/8" # subslot = libcheese soname version
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gtk-doc +introspection test X"
RESTRICT="test" # Tests fail

REQUIRED_USE="test? ( X )"
COMMON_DEPEND="
	>=dev-libs/glib-2.39.90:2
	>=x11-libs/gtk+-3.13.4:3[introspection?]
	>=gnome-base/gnome-desktop-2.91.6:3=
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.13.2:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	media-libs/clutter-gst:3.0
	media-libs/cogl:1.0=[introspection?]

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]

	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-base-1.4:1.0[introspection?,ogg,pango,theora,vorbis,X?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )

	X? (
		x11-base/xorg-proto
		x11-libs/libX11
	)
"

DEPEND="
	${COMMON_DEPEND}
	test? ( x11-libs/libXtst )
"

RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-good-1.4:1.0

	>=media-plugins/gst-plugins-jpeg-1.4:1.0
	>=media-plugins/gst-plugins-v4l2-1.4:1.0
	>=media-plugins/gst-plugins-vpx-1.4:1.0
"

BDEPEND="
	$(vala_depend)
	app-text/docbook-xml-dtd:4.3
	dev-util/itstool
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	dev-libs/libxslt
	dev-libs/libxml2:2
	dev-util/glib-utils
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-buildfix.patch
	"${FILESDIR}"/${P}-help-No-more-menu-bars-in-3.34-UI.patch
)

src_prepare() {
	vala_src_prepare

	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use test tests)
		-Dman=true
	)

	meson_src_configure

	# Hack: version.xml is not generated if gtk-doc is not enabled
	echo ${PV} > docs/reference/version.xml
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
