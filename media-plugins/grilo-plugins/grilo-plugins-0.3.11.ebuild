# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg

DESCRIPTION="A collection of plugins for the Grilo framework"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="daap chromaprint flickr freebox gnome-online-accounts lua test thetvdb tracker upnp-av +youtube"
RESTRICT="!test? ( test )"

# GOA is only optionally used by flickr and lua-factory plugins (checked at v0.3.8)
# json-glib used by tmdb and lua; tmdb currently non-optional
# TODO: validate upnp-av dleyna deps
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=media-libs/grilo-0.3.8:${SLOT}=[network,playlist]
	freebox? (
		net-dns/avahi[dbus] )
	>=dev-libs/gom-0.3.2-r1
	chromaprint? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-chromaprint:1.0 )
	dev-libs/json-glib
	daap? (
		>=net-libs/libdmapsharing-2.9.12:3.0 )
	media-libs/libmediaart:2.0
	net-libs/libsoup:2.4
	dev-libs/libxml2:2
	flickr? (
		net-libs/liboauth )
	dev-db/sqlite:3
	>=dev-libs/totem-pl-parser-3.4.1
	tracker? (
		>=app-misc/tracker-2.3.0:= )
	upnp-av? (
		net-libs/dleyna-connector-dbus
		net-misc/dleyna-server )
	lua? (
		>=dev-lang/lua-5.3
		app-arch/libarchive
		dev-libs/libxml2:2 )
	thetvdb? (
		app-arch/libarchive )
	youtube? (
		>=dev-libs/libgdata-0.9.1:= )

	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.17.91:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.5
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	upnp-av? ( >=dev-util/gdbus-codegen-2.44 )
	virtual/pkgconfig
	lua? ( dev-util/gperf )
"

PATCHES=(
	"${FILESDIR}"/0.3.8-meson-goa.patch # Support controlling g-o-a dep via 'goa' meson_options
)

src_prepare() {
	xdg_src_prepare
	sed -i -e "s:'GETTEXT_PACKAGE', meson.project_name():'GETTEXT_PACKAGE', 'grilo-plugins-${SLOT%/*}':" meson.build || die
	sed -i -e "s:meson.project_name():'grilo-plugins-${SLOT%/*}':" po/meson.build || die
	sed -i -e "s:meson.project_name():'grilo-plugins-${SLOT%/*}':" help/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Denable-bookmarks=yes
		-Denable-chromaprint=$(usex chromaprint yes no)
		-Denable-dleyna=$(usex upnp-av yes no)
		-Denable-dmap=$(usex daap yes no)
		-Denable-filesystem=yes
		-Denable-flickr=$(usex flickr yes no)
		-Denable-freebox=$(usex freebox yes no)
		-Denable-gravatar=yes
		-Denable-jamendo=yes
		-Denable-local-metadata=yes
		-Denable-lua-factory=$(usex lua yes no)
		-Denable-magnatune=yes
		-Denable-metadata-store=yes
		-Denable-opensubtitles=yes
		-Denable-optical-media=yes
		-Denable-podcasts=yes
		-Denable-raitv=yes
		-Denable-shoutcast=yes
		-Denable-thetvdb=$(usex thetvdb yes no)
		-Denable-tmdb=yes
		-Denable-tracker=$(usex tracker yes no)
		-Denable-vimeo=yes
		-Denable-youtube=$(usex youtube yes no)
		-Dgoa=$(usex gnome-online-accounts enabled disabled)
	)
	meson_src_configure
}
