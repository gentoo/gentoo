# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="CD/DVD burning application for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Brasero"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0/3.1" # subslot is 3.suffix of libbrasero-burn3
IUSE="+css +introspection +libburn mp3 nautilus playlist test tracker"
RESTRICT="!test? ( test )"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND="
	>=dev-libs/glib-2.29.14:2
	>=x11-libs/gtk+-3:3[introspection?]
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/libnotify-0.6.1:=

	media-libs/libcanberra[gtk3]
	x11-libs/libICE
	x11-libs/libSM

	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	libburn? (
		>=dev-libs/libburn-0.4:=
		>=dev-libs/libisofs-0.6.4:= )
	nautilus? ( >=gnome-base/nautilus-2.91.90 )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1:= )
	tracker? ( app-misc/tracker:3= )
"
RDEPEND="${DEPEND}
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-meta:1.0[mp3?]
	x11-themes/hicolor-icon-theme
	css? ( media-libs/libdvdcss:1.2 )
	!libburn? (
		app-cdr/cdrdao
		app-cdr/cdrtools
		app-cdr/dvd+rw-tools
	)
"
BDEPEND="
	>=dev-util/intltool-0.50
	dev-util/itstool
	>=dev-util/gtk-doc-am-1.12
	sys-devel/gettext
	virtual/pkgconfig
	test? ( app-text/docbook-xml-dtd:4.3 )
	app-text/yelp-tools
	gnome-base/gnome-common
"
PDEPEND="gnome-base/gvfs"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/brasero/-/merge_requests/10
	"${FILESDIR}"/${P}-tracker3.patch
)

src_configure() {
	gnome2_src_configure \
		--disable-caches \
		$(use_enable !libburn cdrtools) \
		$(use_enable !libburn cdrkit) \
		$(use_enable !libburn cdrdao) \
		$(use_enable !libburn growisofs) \
		$(use_enable introspection) \
		$(use_enable libburn libburnia) \
		$(use_enable nautilus) \
		$(use_enable playlist) \
		$(use_enable tracker search)
}

src_install() {
	gnome2_src_install
	mv "${ED}"/usr/share/{appdata,metainfo} || die
}
