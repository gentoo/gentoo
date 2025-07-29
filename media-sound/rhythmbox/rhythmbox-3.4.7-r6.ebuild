# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"

inherit flag-o-matic gnome.org gnome2-utils python-single-r1 meson virtualx xdg

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Rhythmbox"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

IUSE="X cdr daap dbus keyring gtk-doc ipod libnotify lirc mtp +python test +udev upnp-av"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	ipod? ( udev )
	mtp? ( udev )
	dbus? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	x11-libs/cairo[X?]
	>=x11-libs/gdk-pixbuf-2.18:2
	>=dev-libs/glib-2.66.0:2
	>=dev-libs/gobject-introspection-0.10:=
	>=media-libs/gstreamer-1.4.0:1.0[introspection]
	>=media-libs/gst-plugins-base-1.4.0:1.0[introspection]
	>=x11-libs/gtk+-3.20.0:3[X?,introspection]
	dev-libs/json-glib
	>=dev-libs/libpeas-0.7.3:0[gtk]
	>=net-libs/libsoup-3.0.7:3.0
	>=dev-libs/libxml2-2.7.8:2=
	x11-libs/pango[X?]
	>=sys-libs/tdb-1.2.6
	>=dev-libs/totem-pl-parser-3.2:=

	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		>=net-libs/libdmapsharing-3.9.11:4.0=
		>=media-plugins/gst-plugins-soup-1.4:1.0
	)
	keyring? ( >=app-crypt/libsecret-0.18 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc[X?] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.0:3[${PYTHON_USEDEP}]
		')
	)
	udev? (
		dev-libs/libgudev:=
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 )
	)
"
RDEPEND="${DEPEND}
	media-plugins/gst-plugins-soup:1.0
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0
	)
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/adwaita-icon-theme
	python? (
		>=dev-libs/libpeas-0.7.3:0[python,${PYTHON_SINGLE_USEDEP}]
		net-libs/libsoup:3.0[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( sys-apps/dbus )
		keyring? ( >=app-crypt/libsecret-0.18[introspection] )
	)
	upnp-av? (
		>=media-libs/grilo-0.3.15-r1:0.3
		>=media-plugins/grilo-plugins-0.3.16:0.3[upnp-av]
	)
"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
	dev-util/itstool
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${P}-implicit-declaration.patch
	"${FILESDIR}"/${P}-libxml2-2.12.patch
	"${FILESDIR}"/${P}-libxml-entities.patch
	"${FILESDIR}"/${P}-python3.12.patch
	"${FILESDIR}"/${P}-skip-broken-test.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		$(meson_feature cdr brasero)
		$(meson_feature daap)
		-Dfm_radio=enabled
		$(meson_feature upnp-av grilo)
		$(meson_feature udev gudev)
		$(meson_feature ipod)
		$(meson_feature libnotify)
		$(meson_feature keyring libsecret)
		$(meson_feature lirc)
		$(meson_feature mtp)
		$(meson_feature python plugins_python)
		-Dplugins_vala=disabled
		-Dsample-plugins=false

		-Dhelp=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_feature test tests)
	)
	meson_src_configure
}

src_test() {
	unset SESSION_MANAGER
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
