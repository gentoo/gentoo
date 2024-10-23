# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala virtualx xdg

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="https://wiki.gnome.org/Apps/Cheese"

LICENSE="GPL-2+"
SLOT="0/8" # subslot = libcheese soname version
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"

DEPEND="
	>=media-libs/clutter-1.13.2:1.0[introspection?]
	media-libs/clutter-gst:3.0
	>=media-libs/clutter-gtk-0.91.8:1.0
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	>=dev-libs/glib-2.39.90:2
	>=gnome-base/gnome-desktop-2.91.6:3=
	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-base-1.4:1.0[ogg,pango,theora,vorbis]
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=x11-libs/gtk+-3.13.4:3
	|| (
		media-libs/libcanberra-gtk3
		>=media-libs/libcanberra-0.26[gtk3(-)]
	)
	x11-libs/libX11
	sys-apps/dbus
	media-video/gnome-video-effects
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )

	media-libs/cogl:1.0=[introspection?]

"
RDEPEND="${DEPEND}
	>=media-libs/gst-plugins-good-1.4:1.0

	>=media-plugins/gst-plugins-jpeg-1.4:1.0
	|| (
		>=media-plugins/gst-plugins-v4l2-1.4:1.0
		media-video/pipewire[gstreamer,v4l]
	)
	>=media-plugins/gst-plugins-vpx-1.4:1.0
"

BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
	dev-libs/libxslt
	app-text/docbook-xml-dtd:4.3
	dev-util/itstool
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( x11-libs/libXtst )
	$(vala_depend)
"

PATCHES=(
	"${FILESDIR}"/${PN}-43.0-buildfix.patch
)

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
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
	gnome2_environment_reset # Avoid dconf that looks at XDG_DATA_DIRS, which can sandbox fail if flatpak is installed
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
