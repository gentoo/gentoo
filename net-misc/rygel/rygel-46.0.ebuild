# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit gnome.org meson python-any-r1 systemd vala xdg

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/rygel/"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gtk gtk-doc +introspection +sqlite tracker test transcode"
RESTRICT="!test? ( test )"

# x11-libs/libX11 from qa-vdb
DEPEND="
	>=net-libs/gupnp-1.5.2:1.6=[vala]
	>=dev-libs/libgee-0.8:0.8=
	>=net-libs/gssdp-1.5.0:1.6=[vala]
	>=dev-libs/glib-2.62.0:2
	>=dev-libs/libxml2-2.7:2=
	>=net-libs/gupnp-av-0.14.1:=[vala]
	>=media-libs/gupnp-dlna-0.9.4:2.0=
	>=net-libs/libsoup-3.2.0:3.0
	sqlite? (
		>=dev-db/sqlite-3.5:3
		dev-libs/libunistring:=
	)
	>=media-libs/gstreamer-1.20:1.0
	>=media-libs/gst-plugins-base-1.20:1.0
	media-libs/gstreamer-editing-services:1.0
	>=media-libs/libmediaart-0.7:2.0[vala]
	media-plugins/gst-plugins-soup:1.0
	x11-libs/gdk-pixbuf:2
	>=sys-apps/util-linux-2.20
	x11-misc/shared-mime-info
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	tracker? ( app-misc/tinysparql:3=[vala(+)] )
	transcode? (
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	gtk? ( >=gui-libs/gtk-4.14:4 )

	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-1.8.0
	$(vala_depend)
	app-text/docbook-xml-dtd:4.5
	dev-python/docutils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
"
# Maintainer only
#   app-text/docbook-xsl-stylesheets
#	>=dev-lang/vala-0.36

python_check_deps() {
	python_has_version -b \
		"dev-python/pyyaml[${PYTHON_USEDEP}]"
}

src_prepare() {
	vala_setup
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc api-docs)
		-Dman-pages=true
		-Dsystemd-user-units-dir=$(systemd_get_userunitdir)
		-Dplugins=gst-launch$(use sqlite && echo ",media-export")$(use tracker && echo ",localsearch")
		-Dengines=gstreamer
		-Dexamples=false
		$(meson_use test tests)
		-Dgstreamer=enabled
		$(meson_feature gtk)
		$(meson_feature introspection)
	)
	meson_src_configure
}
