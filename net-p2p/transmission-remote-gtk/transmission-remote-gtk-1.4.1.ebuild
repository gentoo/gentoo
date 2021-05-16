# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="GTK+ client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="https://github.com/transmission-remote-gtk/transmission-remote-gtk"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ayatana debug geoip libnotify libproxy rss"

# RESTRICT="test"

# FIXME: bundles rss-glib-0.2.3
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.12.6
	net-misc/curl
	>=x11-libs/gtk+-3.16:3
	ayatana? ( dev-libs/libappindicator:3 )
	geoip? ( dev-libs/geoip )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	libproxy? ( net-libs/libproxy )
	rss? ( >=net-libs/libmrss-0.18 )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
" # eautoreconf needs sys-devel/autoconf-archive

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-gcc10-fno-common.patch # merged, remove on bump
)

src_configure() {
	# Disable overly strict appdata validation
	gnome2_src_configure \
		$(use_enable debug) \
		$(use_with geoip libgeoip) \
		$(use_with libnotify) \
		$(use_with libproxy) \
		$(use_with ayatana libappindicator) \
		$(use_with rss libmrss) \
		APPSTREAM_UTIL="$(type -P true)"
}
