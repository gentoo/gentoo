# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils xdg-utils virtualx

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/muffin"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection test xinerama"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/json-glib-1.0
	>=gnome-extra/cinnamon-desktop-4.8:0=
	gnome-extra/zenity
	>=media-libs/libcanberra-0.26[gtk3]
	virtual/opengl
	>=x11-libs/cairo-1.14:=[X]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.9.12:3[X,introspection?]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	>=x11-libs/libXcomposite-0.3
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXi-1.6.0
	>=x11-libs/libxkbcommon-0.4.3
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/pango-1.14.0[X,introspection?]
	>=x11-libs/startup-notification-0.7:=
	x11-misc/xkeyboard-config

	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto

	test? ( app-text/docbook-xml-dtd:4.5 )
"
# needs gtk-doc, not just -am, for gtk-doc.make
BDEPEND="
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
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

src_test() {
	virtx default
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
