# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 python-single-r1 multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Rhythmbox"

LICENSE="GPL-2"
SLOT="0"

IUSE="cdr daap dbus gnome-keyring ipod libnotify lirc mtp +python test +udev upnp-av"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	ipod? ( udev )
	mtp? ( udev )
	dbus? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/libxml2-2.7.8:2
	>=x11-libs/gtk+-3.20.0:3[X,introspection]
	>=x11-libs/gdk-pixbuf-2.18:2
	>=dev-libs/gobject-introspection-0.10:=
	>=dev-libs/libpeas-0.7.3[gtk]
	>=dev-libs/totem-pl-parser-3.2
	>=net-libs/libsoup-2.42:2.4
	>=media-libs/gst-plugins-base-1.4:1.0[introspection]
	>=media-libs/gstreamer-1.4:1.0[introspection]
	>=sys-libs/tdb-1.2.6
	dev-libs/json-glib

	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		>=net-libs/libdmapsharing-2.9.19:3.0
		>=media-plugins/gst-plugins-soup-1.4:1.0 )
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.0:3[${PYTHON_MULTI_USEDEP}]
		')
	)
	udev? (
		dev-libs/libgudev:=
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 ) )
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-libmms:1.0
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/adwaita-icon-theme
	python? (
		>=dev-libs/libpeas-0.7.3[python,${PYTHON_SINGLE_USEDEP}]
		net-libs/libsoup:2.4[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( sys-apps/dbus )
		gnome-keyring? ( >=app-crypt/libsecret-0.18[introspection] ) )
	upnp-av? (
		>=media-libs/grilo-0.3:0.3
		>=media-plugins/grilo-plugins-0.3:0.3[upnp-av] )
"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	dev-util/itstool
	virtual/pkgconfig
	test? ( dev-libs/check )
"
# eautoreconf needs yelp-tools

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# --enable-vala just installs the sample vala plugin, and the configure
	# checks are broken, so don't enable it
	gnome2_src_configure \
		VALAC=$(type -P true) \
		--enable-mmkeys \
		--disable-more-warnings \
		--disable-static \
		--disable-vala \
		$(use_enable daap) \
		$(use_enable libnotify) \
		$(use_enable lirc) \
		$(use_enable python) \
		$(use_enable upnp-av grilo) \
		$(use_with cdr brasero) \
		$(use_with gnome-keyring libsecret) \
		$(use_with ipod) \
		$(use_with mtp) \
		$(use_with udev gudev)
}

src_test() {
	unset SESSION_MANAGER
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check CK_DEFAULT_TIMEOUT=60
}

src_install() {
	DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
		MAINTAINERS MAINTAINERS.old NEWS README THANKS"

	gnome2_src_install
}
