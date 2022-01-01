# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils gnome2-utils xdg-utils

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection test xinerama"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="test"

RDEPEND="
	>=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.14:=[X]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.9.12:3[X,introspection?]
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/json-glib-1.0
	>=gnome-extra/cinnamon-desktop-4.4:0=
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/libXcomposite-0.3
	>=x11-libs/startup-notification-0.7:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxkbcommon
	virtual/opengl

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
"
# needs gtk-doc, not just -am, for gtk-doc.make
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	xdg_environment_reset
	default
	eautoreconf
	gnome2_disable_deprecation_warning
}

# Wayland is not supported upstream.
src_configure() {
	econf \
		--disable-gtk-doc \
		--disable-maintainer-mode \
		--disable-schemas-compile \
		--enable-compile-warnings=minimum \
		--disable-static \
		--enable-shape \
		--enable-sm \
		--enable-startup-notification \
		--enable-xsync \
		--enable-verbose-mode \
		--with-libcanberra \
		$(use_enable introspection) \
		$(use_enable xinerama)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	dodoc HACKING MAINTAINERS *.txt doc/*.txt
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
