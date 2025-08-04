# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-{3,4} )
inherit gnome.org lua-single meson xdg

DESCRIPTION="A collection of plugins for the Grilo framework"
HOMEPAGE="https://gitlab.gnome.org/GNOME/grilo-plugins"

LICENSE="LGPL-2.1+"
SLOT="0.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="daap chromaprint flickr freebox gnome-online-accounts lua test thetvdb tracker upnp-av +youtube"
RESTRICT="!test? ( test )"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

# GOA is only optionally used by lua-factory plugins (checked at v0.3.16)
# json-glib used by tmdb and lua; tmdb currently non-optional
# TODO: validate upnp-av dleyna deps
RDEPEND="
	>=dev-libs/glib-2.66:2
	>=media-libs/grilo-0.3.15-r1:${SLOT}=[playlist]
	freebox? ( net-dns/avahi[dbus] )
	>=dev-libs/gom-0.4
	chromaprint? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-chromaprint:1.0
	)
	dev-libs/json-glib
	daap? ( >=net-libs/libdmapsharing-3.9.11:4.0= )
	media-libs/libmediaart:2.0
	net-libs/libsoup:3.0
	dev-libs/libxml2:2=
	flickr? ( net-libs/liboauth )
	dev-db/sqlite:3
	>=dev-libs/totem-pl-parser-3.4.1:=
	tracker? ( app-misc/tinysparql:3= )
	upnp-av? ( net-libs/dleyna:1.0= )
	lua? (
		${LUA_DEPS}
		app-arch/libarchive
		net-libs/rest:1.0
		dev-libs/libxml2:2=
		gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.17.91:= )
	)
	thetvdb? ( app-arch/libarchive )
	youtube? ( >=dev-libs/libgdata-0.17.0:= )
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

pkg_pretend() {
	if use gnome-online-accounts; then
		if ! use lua; then
			ewarn "Ignoring USE=gnome-online-accounts USE does not contain lua"
		fi
	fi
}

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset

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
		-Denable-local-metadata=yes
		-Denable-lua-factory=$(usex lua yes no)
		-Denable-magnatune=yes
		-Denable-metadata-store=yes
		-Denable-optical-media=yes
		-Denable-podcasts=yes
		-Denable-shoutcast=yes
		-Denable-thetvdb=$(usex thetvdb yes no)
		-Denable-tmdb=yes
		-Denable-tracker=no
		-Denable-tracker3=$(usex tracker yes no)
		-Denable-youtube=$(usex youtube yes no)
		-Dhelp=no
	)
	if use lua; then
		emesonargs+=($(meson_feature gnome-online-accounts goa))
	else
		emesonargs+=(-Dgoa=disabled)
	fi
	meson_src_configure
}
